// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;


/*
    作业 1：ERC20 代币
    任务：参考 openzeppelin-contracts/contracts/token/ERC20/IERC20.sol实现一个简单的 ERC20 代币合约。要求：
    合约包含以下标准 ERC20 功能：
    balanceOf：查询账户余额。
    transfer：转账。
    approve 和 transferFrom：授权和代扣转账。
    使用 event 记录转账和授权操作。
    提供 mint 函数，允许合约所有者增发代币。
    提示：
    使用 mapping 存储账户余额和授权信息。
    使用 event 定义 Transfer 和 Approval 事件。
    部署到sepolia 测试网，导入到自己的钱包
*/
contract MyTokenTask {

    
    //基本状态信息
    string private _name;
    string private _symbol;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    //授权方 => 被授权方 => 授权金额）
    mapping(address => mapping(address => uint256)) private _allowances;
    //合约所有者
    address private _owner;

    //事件信息
    event Transfer(address indexed from,address indexed to ,uint256 value);
    event Approval(address indexed owner,address indexed spender,uint256 value);

    //构造方法
    constructor(){
        _name = "MyTokenTask";
        _symbol = "MTT";
        _owner = msg.sender;
        _totalSupply = 1000000;
        _balances[_owner] = _totalSupply;
        emit Transfer(address(0),_owner,_totalSupply);//创建代币,合约所有者初始化为1000000
    }
    //修饰符,加载前后逻辑
    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can call this function");
        _;
    }
    
    function mint(address account,uint256 value) public onlyOwner{
        require(account != address(0), "Mint to the zero address");
        _totalSupply += value;
        _balances[account] += value;
        emit Transfer(address(0), account, value);
    }

    //基本方法
    function balanceOf(address account) public view returns(uint256){
        return _balances[account];
    }
    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }
    // transfer：转账。
    // approve 和 transferFrom：授权和代扣转账。
    function transfer(address to,uint256 value) public  returns(bool){
        require(to != address(0),'invalid to address');
        require(_balances[msg.sender] >= value,'insufficient balance');

        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender,uint256 value) public returns (bool){
       
        require(msg.sender != address(0), "Approve from the zero address");
        // 确保被授权方不为0地址
        require(spender != address(0), "Approve to the zero address");

        // 更新授权金额
        _allowances[msg.sender][spender] = value;

        // 触发Approval事件
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }
    
     function transferFrom(address from,address to,uint256 value) public  returns(bool){
        require(from != address(0),'invalid from address');
        require(to != address(0),'invalid to address');
        require(_balances[from] >= value,'insufficient balance');
        require(_allowances[from][msg.sender] >= value,'insufficient allowance');
        _balances[from] -= value;
        _balances[to] += value;
        emit Transfer(from, to, value);
        return true;
     }

    

    


    

}