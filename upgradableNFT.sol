// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "https://github.com/chiru-labs/ERC721A-Upgradeable/blob/main/contracts/ERC721AUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "https://github.com/limitbreakinc/creator-token-contracts/blob/main/contracts/programmable-royalties/BasicRoyalties.sol";


contract TheUpgradeableERC721C is ERC721AUpgradeable, Initializable, OwnableUpgradeable, UUPSUpgradeable
{
   string _baseTokenURI;
   uint256 NftPrice=2*10**18; 
   IERC20 PaymentToken; 
 
   struct NftlistForSale{
    address seller; 
    uint256 _tokenId; 
    uint256 Price;
    bool Active; 
   }


   mapping( uint256=> NftlistForSale) public  NflSalelist; 


  event Sold(uint256 tokenId, address buyer, uint256 price);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor( address _paymentToken){ 
          PaymentToken=IERC20(_paymentToken);
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer  { 
        __ERC721A_init("My token", "Mtk");
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
    }


    function checkTokenBalance( address _account) public view returns( uint256) {
        return PaymentToken.balanceOf(_account);
    }

  function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}

    function BuyNft( uint _tokenId) external {
      require(PaymentToken.balanceOf(msg.sender)>NftPrice, "insufficeint balance");
       transferFrom( ownerOf(_tokenId), msg.sender, _tokenId);
       PaymentToken.transfer(ownerOf(_tokenId), NftPrice);
       emit  Sold(_tokenId, msg.sender, NftPrice);

    }

    function SellNft() external {

    }

   

    function  PublicMint(uint256 _quantity ) public {
     _mint(msg.sender, _quantity );
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721AUpgradeable)
        returns (bool)
    {
        return
            ERC721AUpgradeable.supportsInterface(interfaceId);
    }


    /**
     * @notice Override ERC721AC _baseURI function to use base URI pattern
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return currentBaseURI;
        
    }

    /**
     * @notice Return the number of tokens an address has minted
     * @param account Address to return the number of tokens minted for
     */
    function numberMinted(address account) external view returns (uint256) {
        return _numberMinted(account);
    }
    function setBaseURI(string calldata _newBaseURI)
        external
        onlyOwner
    {
        _baseTokenURI = _newBaseURI;
    }



    function setApprovalForAll(address operator, bool approved)
        public
        override
    {
        super.setApprovalForAll(operator, approved);
    }


    function approve(address operator, uint256 tokenId)
        public
        payable
        override
    {
        super.approve(operator, tokenId);
    }


    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    )
        public
        payable
        override
    {
        super.transferFrom(from, to, tokenId);
    }


    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    )
        public
        payable
        override
    {
        super.safeTransferFrom(from, to, tokenId);
    }

 
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    )
        public
        payable
        override
    {
        super.safeTransferFrom(from, to, tokenId, data);
    }

    

} 
