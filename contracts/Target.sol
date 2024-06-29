// SPDX-License-Identifier: UNKNOWN 
pragma solidity ^0.7.0;

contract TargetContract {
    address private _owner;
    address private _proxy;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;

    constructor(address owner, address proxy) {
      _owner = owner;
      _proxy = proxy;
    }

    // Modifiers
    modifier onlyOwner() {
        // Exploit 4 : Authorization Through tx.origin
        // Solution : require(msg.sender == _owner);
        require(tx.origin == _owner, "Only Owner");
        _;
    }

    // View Functions
    function owner() public view returns (address) {
        return _owner;
    }

    function proxy() public view returns (address) {
        return _proxy;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balance(address account) public view returns (uint256) {
        return _balances[account];
    }

    function allowance(address account, address spender) public view returns (uint256) {
        return _allowances[account][spender];
    }

    // Public / External Funtions
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function mint(address account, uint256 value) public onlyOwner returns (bool) {
        _mint(account, value);
        return true;
    }

    function deposit() public payable returns (bool) {
        _deposit(msg.sender, msg.value);
        return true;
    }

    function withdraw() public returns (bool) {
        _withdraw(msg.sender);
        return true;
    }

    function changeProxy(address proxyAddress) public returns (bool) {
        (bool success, ) = _proxy.delegatecall(
            abi.encodeWithSignature("changeProxy(address)", proxyAddress)
        );
        require(success, "TargetContract: Failed to call proxy");
        return true;
    }

    receive() external payable {}

    fallback() external payable {}

    // Private / Internal Functions
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        if(msg.sender != sender) {
            require(_allowances[sender][msg.sender] >= amount, "Not enough allowance");
        }

        // Exploit 2 : Underflow
        // Solution : require correct amount, update solidity version to post 0.8, implement safeMath library
        _balances[sender] = _balances[sender] - amount;
        // Exploit 2 : Overflow
        // Solution : require correct amount, update solidity version to post 0.8, implement safeMath library
        _balances[recipient] = _balances[recipient] + amount;
    }

    // Exploit 1 : Function Exposure
    // Solution : make function internal
    function _approve(address account, address spender, uint256 value) public {
        require(account != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[account][spender] = value;
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply + amount;
        _balances[account] = _balances[account] + amount;
    }

    function _deposit(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: deposit to the zero address");
        require(amount == msg.value, "ERC20: deposit to the zero address");
        _balances[account] = _balances[account] + amount;
    }

    function _withdraw(address account) internal {
        require(_balances[account] > 0, "ERC20: Not enough balance");

        // Exploit 3 : Reentrancy Attack
        // Solution : _balances[account] = 0; before transfer
        (bool success, ) = msg.sender.call{value : _balances[account]}("");
        require(success, "ERC20: Failed to send ether");

        _balances[account] = 0;
    }
}

contract ProxyTargetContract {
    // Exploit 5 : Storage Collision with Delegate Call
    // Solution : change _proxy with _owner
    address private _owner;
    address private _proxy;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;

    function changeProxy(address proxy) public returns (bool) {
        _proxy = proxy;
    }

}