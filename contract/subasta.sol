// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Subasta {
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }

    struct AuctionItem {
        string name;
        uint256 value;
        address owner;
        address winning_bidder;
        bool isActive;
        uint256 endTime;
    }

    struct Offer {
        address bidder;
        uint256 value;
    }

    AuctionItem[] public auctionItems;
    mapping(uint256 => mapping(address => uint256)) public userDeposits;
    mapping(uint256 => mapping(address => uint256)) public userLastBid;

    event AuctionCreated(
        uint256 indexed auctionId,
        string name,
        uint256 startingPrice,
        address indexed owner,
        uint256 endTime
    );

    event NuevaOferta(
        uint256 indexed auctionId,
        address indexed bidder,
        uint256 amount,
        uint256 newEndTime
    );

    event SubastaFinalizada(
        uint256 indexed auctionId,
        address indexed winner,
        uint256 winningBid
    );

    event AuctionExtended(
        uint256 indexed auctionId,
        uint256 newEndTime,
        uint256 timeAdded
    );

    event PartialWithdraw(
        uint256 indexed auctionId,
        address indexed user,
        uint256 amount
    );

    modifier validIncrement(uint256 _idAuctionItem, uint256 _newOffer) {
        require(_idAuctionItem < auctionItems.length, "Item no existe");

        uint256 currentValue = auctionItems[_idAuctionItem].value;

        if (currentValue == 0) {
            require(
                _newOffer >= auctionItems[_idAuctionItem].value,
                "Oferta debe ser >= precio inicial"
            );
        } else {
            uint256 minRequiredBid = currentValue + ((currentValue * 5) / 100);
            require(
                _newOffer >= minRequiredBid,
                "Oferta debe ser al menos 5% mayor"
            );
        }
        _;
    }

    modifier onlyActiveAuction(uint256 _idAuctionItem) {
        require(_idAuctionItem < auctionItems.length, "Item no existe");
        require(auctionItems[_idAuctionItem].isActive, "Subasta no esta activa");
        require(block.timestamp < auctionItems[_idAuctionItem].endTime, "Subasta ha terminado");
        _;
    }

    function createAuctionItem(string memory _name, uint256 _value, uint256 _duration) public {
        uint256 auctionId = auctionItems.length;
        uint256 endTime = block.timestamp + _duration;
        
        AuctionItem memory newItem = AuctionItem({
            name: _name,
            value: _value,
            owner: msg.sender,
            winning_bidder: address(0),
            isActive: true,
            endTime: endTime
        });

        auctionItems.push(newItem);
        
        emit AuctionCreated(auctionId, _name, _value, msg.sender, endTime);
    }

    function getAuctionItem(uint256 _idAuctionItem)
        public
        view
        returns (AuctionItem memory)
    {
        require(_idAuctionItem < auctionItems.length, "Item no existe");
        return auctionItems[_idAuctionItem];
    }

    function createOffer(uint256 _idAuctionItem, uint256 _newOffer)
        public
        payable
       
        validIncrement(_idAuctionItem, _newOffer)
    {
        
       
        userLastBid[_idAuctionItem][msg.sender] = _newOffer;
        
        auctionItems[_idAuctionItem].winning_bidder = msg.sender;
        auctionItems[_idAuctionItem].value = _newOffer;
        
        uint256 originalEndTime = auctionItems[_idAuctionItem].endTime;
        uint256 timeLeft = originalEndTime - block.timestamp;
        
        if (timeLeft <= 10 minutes) {
            uint256 newEndTime = block.timestamp + 10 minutes;
            auctionItems[_idAuctionItem].endTime = newEndTime;
            emit AuctionExtended(_idAuctionItem, newEndTime, 10 minutes);
        }
        
        emit NuevaOferta(
            _idAuctionItem, 
            msg.sender, 
            _newOffer, 
            auctionItems[_idAuctionItem].endTime
        );
    }

    function finalizeAuction(uint256 _idAuctionItem) public {
        require(_idAuctionItem < auctionItems.length, "Item no existe");
        require(auctionItems[_idAuctionItem].isActive, "Subasta ya finalizada");
        require(
            msg.sender == auctionItems[_idAuctionItem].owner || 
            block.timestamp >= auctionItems[_idAuctionItem].endTime,
            "Solo el owner puede finalizar o tiempo expirado"
        );

        auctionItems[_idAuctionItem].isActive = false;
        
        emit SubastaFinalizada(
            _idAuctionItem,
            auctionItems[_idAuctionItem].winning_bidder,
            auctionItems[_idAuctionItem].value
        );
    }

    function autoFinalizeAuction(uint256 _idAuctionItem) public {
        require(_idAuctionItem < auctionItems.length, "Item no existe");
        require(auctionItems[_idAuctionItem].isActive, "Subasta ya finalizada");
        require(block.timestamp >= auctionItems[_idAuctionItem].endTime, "Subasta aun activa");
        
        auctionItems[_idAuctionItem].isActive = false;
        
        emit SubastaFinalizada(
            _idAuctionItem,
            auctionItems[_idAuctionItem].winning_bidder,
            auctionItems[_idAuctionItem].value
        );
    }

    function withdrawPartial(uint256 _idAuctionItem, uint256 _amount) public {
        require(_idAuctionItem < auctionItems.length, "Item no existe");
        require(auctionItems[_idAuctionItem].isActive, "Solo durante subasta activa");
        
        uint256 userTotalDeposit = userDeposits[_idAuctionItem][msg.sender];
        uint256 userCurrentBid = userLastBid[_idAuctionItem][msg.sender];
        
        require(userTotalDeposit > 0, "No tienes depositos");
        require(_amount > 0, "Cantidad debe ser mayor a 0");
        
        uint256 availableToWithdraw = userTotalDeposit - userCurrentBid;
        require(availableToWithdraw >= _amount, "Cantidad excede el disponible");
        
        userDeposits[_idAuctionItem][msg.sender] -= _amount;
        
        payable(msg.sender).transfer(_amount);
        
        emit PartialWithdraw(_idAuctionItem, msg.sender, _amount);
    }

    function getAuctionCount() public view returns (uint256) {
        return auctionItems.length;
    }

    function isAuctionActive(uint256 _idAuctionItem) public view returns (bool) {
        require(_idAuctionItem < auctionItems.length, "Item no existe");
        return auctionItems[_idAuctionItem].isActive;
    }

    function getTimeLeft(uint256 _idAuctionItem) public view returns (uint256) {
        require(_idAuctionItem < auctionItems.length, "Item no existe");
        
        if (block.timestamp >= auctionItems[_idAuctionItem].endTime) {
            return 0;
        }
        
        return auctionItems[_idAuctionItem].endTime - block.timestamp;
    }

    function getUserDeposit(uint256 _idAuctionItem, address _user) public view returns (uint256) {
        return userDeposits[_idAuctionItem][_user];
    }

    function getUserLastBid(uint256 _idAuctionItem, address _user) public view returns (uint256) {
        return userLastBid[_idAuctionItem][_user];
    }

    function getWithdrawableAmount(uint256 _idAuctionItem, address _user) public view returns (uint256) {
        uint256 totalDeposit = userDeposits[_idAuctionItem][_user];
        uint256 lastBid = userLastBid[_idAuctionItem][_user];
        
        if (totalDeposit > lastBid) {
            return totalDeposit - lastBid;
        }
        return 0;
    }
}