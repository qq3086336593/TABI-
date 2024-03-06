// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BasicToken {
    string public name;            // 代币名称
    string public symbol;          // 代币符号
    uint8 public decimals;         // 小数点位数
    uint256 public totalSupply;    // 总供应量
    address public owner;          // 合约所有者，可以是管理员
    mapping(address => uint256) public balanceOf;  // 地址对应的余额
    mapping(address => bool) public isAdmin;       // 是否是管理员

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10**uint256(decimals);
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        isAdmin[msg.sender] = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Only admin can call this function");
        _;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function mint(address _to, uint256 _value) public onlyAdmin returns (bool success) {
        totalSupply += _value;
        balanceOf[_to] += _value;
        emit Mint(_to, _value);
        return true;
    }

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }

    function addAdmin(address _admin) public onlyOwner {
        isAdmin[_admin] = true;
    }

    function removeAdmin(address _admin) public onlyOwner {
        isAdmin[_admin] = false;
    }
}
