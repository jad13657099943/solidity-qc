/**
 *Submitted for verification at hecoinfo.com on 2021-02-03
*/

pragma solidity =0.6.6;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }


    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }


    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }


    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }


    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }


    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }


    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }


    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


abstract contract Pausable is Context {

    event Paused(address account);


    event Unpaused(address account);

    bool private _paused;

    constructor () internal {
        _paused = false;
    }


    function paused() public view returns (bool) {
        return _paused;
    }


    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }


    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }


    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }


    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}
contract TOKEN{
     function balanceOf(address account) public view  returns (uint256) {}
     function transfer(address recipient, uint256 amount) public  returns (bool) {}
     function transferFrom(address sender, address recipient, uint256 amount) public  returns (bool) {}
}
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    address private master;
    address public masters;
    TOKEN public token;
    uint8 public sbv=1;
    uint256 public total=95000000000000;
    uint8 public day=6;
    uint8 public hour=12;
    uint8 public buy=5;
    uint256 public dbl=2; 
    mapping(uint256=>uint8)  public timeBuy;
    mapping(uint256=>uint8) public timeDay;
    mapping(uint256=>uint256) public timeDbl;
    uint256 public time;
    uint256 public week=86400*7;
    
    mapping (address=>uint256) public userTime;
    mapping (address=>uint256) public usdt;
    
    struct Record{
        uint256 balance;
        uint256 time;
    }
    mapping(address=>Record[]) public userRecord;
     
    constructor (string memory name_, string memory symbol_,uint8  decimals,uint256  totalSupply,address _token,uint256 _time) public {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals;
        _totalSupply=totalSupply;
         _balances[msg.sender] = totalSupply;
         master=msg.sender;
          token=TOKEN(_token);
          time=_time;
    }

    modifier only(){
        require(msg.sender==master,"You're not the master.");
        _;
    }
    
    modifier onlys(){
        require(msg.sender==masters,"You're not the master.");
        _;
    }
    
     function setMasters(address _masters)public only returns(bool){
            masters=_masters;
            return true;
    }
    
    function setDay(uint8 _day)public onlys returns(bool){
              uint256 Time=block.timestamp;
              uint256 ci= (Time-time))/week;
              if(ci>1){
                    if(Time>time+(week*ci)+(day*86400)+(hour*3600)){
                  timeDay[time+week*(ci+1)]=1;
                    }
              }else{
                       if(Time>time+(day*86400)+(hour*3600)){
                  timeDay[time+week*(ci+1)]=1;
                    }
              }
            day=_day;
            return true;
    }
    
    function setHour(uint8 _hour)public onlys returns(bool){
            hour=_hour;
            return true;
    }
    
      function guBuy(uint256 _time,uint8 _buy) private{
        if(timeBuy[_time]<1){
             timeBuy[_time]=_buy;
        }
    }
    
     function guDbl(uint256 _time,uint256 _dbl) private{
         if(timeDbl[_time]<1){
             timeDbl[_time]=_dbl;
         }
     }
    
    function setBuy(uint8 _buy)public onlys returns(bool){
           uint256 Time=block.timestamp;
              uint256 ci= (Time-time)/week;
                    if(Time>time+(week*ci)+(day*86400)+(hour*3600)){
                      timeBuy[time+week*(ci+1)]=buy;
                    }
                    for(uint256 a=ci;a>=1;a--){
                    uint256 ztime=time+(week*a);
                    if(timeBuy[ztime]>0){
                        break;
                    }
                    guBuy(ztime,buy);
                    }
                    buy=_buy;
                   return true;
    }
    
    function setDbl(uint256 _dbl) public onlys returns(bool){
         uint256 Time=block.timestamp;
              uint256 ci= (Time-time)/week;
                    if(Time>time+(week*ci)+(day*86400)+(hour*3600)){
                      timeDbl[time+week*(ci+1)]=dbl;
                    }
                   for(uint256 a=ci;a>=1;a--){
                    uint256 ztime=time+(week*a);
                     if(timeDbl[ztime]>0){
                        break;
                    }
                    guDbl(ztime,dbl);
                    }
                   dbl=_dbl;
                   return true;
    }
  
    
    function setTime(address _owner) private{
         if(_owner!=address(this)){
        if(userTime[_owner]<1){
             uint256 Time=block.timestamp;
             uint256 ci= (Time-time)/week;
              if(Time>time+(week*ci)+(day*86400)+(hour*3600)){
                ci+=1;
            }
            userTime[_owner]=time+(week*ci);
        }
         }
    }
    
    function setUsdt(address _owner,uint256 _num) public onlys returns(bool){
        token.transfer(_owner,_num);
    }
    
    function get(address _owner) private{
        uint256 Time=block.timestamp;
        if(userTime[_owner]<Time&&_balances[_owner]>10000&&userTime[_owner]>0){
               uint256 ci=(Time-userTime[_owner])/week;
        if(ci<1){
            if(timeDay[userTime[_owner]+week]==1){
                ci+=1;
            }else{
                  if(Time>userTime[_owner]+(day*86400)+(hour*3600)){
                ci+=1;
            }
            }
          
        }
        if(ci>1){
             if(timeDay[userTime[_owner]+(week*(ci+1))]==1){
                ci+=1;
            }else{
                if(Time>userTime[_owner]+(86400*ci)+(day*86400)+(hour*3600)){
                ci+=1;
            } 
            }
           
        }
        uint256 money = _balances[_owner];
        uint256 usdtNum=0;
        uint256 num=0;
        for(uint256 a=1;a<=ci;a++){
            uint256 ztime=userTime[_owner]+(week*a);
            guBuy(ztime,buy);
            guDbl(ztime,dbl);
            if(timeBuy[ztime]==0){
                 num=money*buy/100;
                 money-=money*buy/100;
                
            }else{
                 num=money*timeBuy[ztime]/100;
                 money-=money*timeBuy[ztime]/100;
                
            }
              if(timeDbl[ztime]==0){
                  usdtNum+=num/dbl;
                }else{
                    usdtNum+=num/timeDbl[ztime];   
                }
           
        }
        uint256 buyNum=_balances[_owner]-money;
        _balances[_owner]-=buyNum;
        _balances[address(this)]+=buyNum;
        usdt[_owner]+=usdtNum;
        userTime[_owner]+=(week*ci);
        }
    }
    
    function show(address _owner) public view returns(uint256){
        uint256 Time=block.timestamp;
        if(userTime[_owner]<Time&&_balances[_owner]>10000&&userTime[_owner]>0){
               uint256 ci=(Time-userTime[_owner])/week;
        if(ci<1){
            if(timeDay[userTime[_owner]+week]==1){
                ci+=1;
            }else{
                  if(Time>userTime[_owner]+(day*86400)+(hour*3600)){
                ci+=1;
            }
            }
          
        }
        if(ci>1){
             if(timeDay[userTime[_owner]+(week*(ci+1))]==1){
                ci+=1;
            }else{
                if(Time>userTime[_owner]+(86400*ci)+(day*86400)+(hour*3600)){
                ci+=1;
            } 
            }
           
        }
        uint256 money = _balances[_owner];
        uint256 usdtNum=0;
        uint256 num=0;
        for(uint256 a=1;a<=ci;a++){
            uint256 ztime=userTime[_owner]+(week*a);
            if(timeBuy[ztime]==0){
                 num=money*buy/100;
                 money-=money*buy/100;
                
            }else{
                 num=money*timeBuy[ztime]/100;
                 money-=money*timeBuy[ztime]/100;
                
            }
              if(timeDbl[ztime]==0){
                  usdtNum+=num/dbl;
                }else{
                    usdtNum+=num/timeDbl[ztime];   
                }
           
        }
        uint256 buyNum=_balances[_owner]-money;
        return buyNum;
        }
    }
    
    function shows(address _owner) public view returns(uint256){
        uint256 Time=block.timestamp;
        if(userTime[_owner]<Time&&_balances[_owner]>10000&&userTime[_owner]>0){
               uint256 ci=(Time-userTime[_owner])/week;
        if(ci<1){
            if(timeDay[userTime[_owner]+week]==1){
                ci+=1;
            }else{
                  if(Time>userTime[_owner]+(day*86400)+(hour*3600)){
                ci+=1;
            }
            }
          
        }
        if(ci>1){
             if(timeDay[userTime[_owner]+(week*(ci+1))]==1){
                ci+=1;
            }else{
                if(Time>userTime[_owner]+(86400*ci)+(day*86400)+(hour*3600)){
                ci+=1;
            } 
            }
           
        }
        uint256 money = _balances[_owner];
        uint256 usdtNum=0;
        uint256 num=0;
        for(uint256 a=1;a<=ci;a++){
            uint256 ztime=userTime[_owner]+(week*a);
            if(timeBuy[ztime]==0){
                 num=money*buy/100;
                 money-=money*buy/100;
            }else{
                 num=money*timeBuy[ztime]/100;
                 money-=money*timeBuy[ztime]/100;
            }
              if(timeDbl[ztime]==0){
                  usdtNum+=num/dbl;
                }else{
                    usdtNum+=num/timeDbl[ztime];   
                }
           
        }
         return usdtNum;
        }
    }
    
    function release(address _to) public onlys returns(bool){
           _transfer(address(this),_to,total*sbv/100);
            return true;
    }
    
    function withdraw() public  returns(bool){
        
        address _owner=msg.sender;
        get(_owner);
        uint256 ke=usdt[_owner];
       
        uint256 you=token.balanceOf(address(this));
        if(ke>0&&you>0&&you>ke){
             usdt[_owner]-=ke;
            token.transfer(_owner,ke);
            userRecord[_owner].push(Record(ke,block.timestamp));
        }
       
    }
    
    function getRecord(address _owner,uint8 _limit) public view returns(uint256[] memory,uint256[] memory){
        uint256 num=userRecord[_owner].length;
        if(num>_limit) num=_limit;
        uint256[] memory money=new uint256[](num);
        uint256[] memory wtime=new uint256[](num);
        for(uint256 i=0;i<num;i++){
            money[i]=userRecord[_owner][i].balance;
            wtime[i]=userRecord[_owner][i].time;
        }
        return(money,wtime);
    } 
  
    function getBuyRecord() public view returns(uint256[] memory,uint256[] memory){
        
    }
    
    
    function name() public view returns (string memory) {
        return _name;
    }


    function symbol() public view returns (string memory) {
        return _symbol;
    }


    function decimals() public view returns (uint8) {
        return _decimals;
    }


    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }


    function balanceOf(address account) public view override returns (uint256) {
                
        return _balances[account]-show(account);
    }

    function balanceOfs(address account) public view  returns (uint256){
        
        return usdt[account]+shows(account);
    }
    
    function usdtBalanceof() public view returns(uint256){
        return token.balanceOf(address(this));
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        
        _transfer(_msgSender(), recipient, amount);
        return true;
    }


    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }


    function approve(address spender, uint256 amount) public virtual override returns (bool) {
          
        _approve(_msgSender(), spender, amount);
        return true;
    }


    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
       
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }


    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    
    
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        get(sender);
        get(recipient);
        setTime(recipient);
        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }


    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }


    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}
abstract contract ERC20Pausable is ERC20, Pausable {
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "ERC20Pausable: token transfer while paused");
    }
}
contract ERC20Template is ERC20Pausable {
    address factory;
    address _operator;
    address _pauser;
    constructor(address operator,address pauser,string memory name, string memory symbol,uint8 decimal,uint256 totalSupply,address _token,uint256 _time) public ERC20(name,symbol,decimal,totalSupply,_token,_time) {
        _operator = operator;
        _pauser=pauser;
        _setupDecimals(decimal);
        factory=msg.sender;
    }


    modifier onlyFactory(){
        require(msg.sender==factory,"only Factory");
        _;
    }
    modifier onlyOperator(){
        require(msg.sender == _operator,"not allowed");
        _;
    }
    modifier onlyPauser(){
        require(msg.sender == _pauser,"not allowed");
        _;
    }

    function pause() public  onlyPauser{
        _pause();
    }

    function unpause() public  onlyPauser{
        _unpause();
    }

    function changeUser(address new_operator, address new_pauser) public onlyFactory{
        _pauser=new_pauser;
        _operator=new_operator;
    }

    function mint(address account, uint256 amount) public whenNotPaused onlyOperator {
        _mint(account, amount);
    }
    function burn(address account , uint256 amount) public whenNotPaused onlyOperator {
        _burn(account,amount);
    }
}