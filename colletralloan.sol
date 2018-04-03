pragma solidity ^0.4.0;
import "./Register.sol";
import "./Bank.sol";
import "./EIP20.sol";
contract Loan_Details is Bank,NewSPToken 
{
    uint public price=0.01 ether;
    //uint256 public ln_req_count=0;
    struct loan_get
    {
        address bank_address;
        uint256 amount;
        uint256 count;
        uint last_setl_time;
        uint time;
        uint months;
        uint bal_ln;
        uint installment;
        uint tcount;
        address token_address;
    }
    mapping (address=>mapping(uint256=>loan_get))public ln_get;
    mapping(address=>uint256)public ln_get_count;
    struct loan_pro
    {
        address bank_address;
        uint256 amount;
        uint time;
        uint months;
        uint256 tokens;
    }
    
    mapping (address=>mapping(uint256=>loan_pro))public ln_pro;
    mapping(address=>uint256)public ln_pro_count;
    
    function req(address _token,address bank_address,uint8 year,uint256 tokens)public payable//returns(uint256,uint256)
    {
        //require(bank_d1[msg.sender].time!=0);
        //require(bank_d1[bank_address].time!=0);
        //require(bank_address!=msg.sender);
       //uint256 amt = (eth * tokens);
        uint amount=tokens*price;   
        require(amount==tokens&& tokens <=balanceOf[msg.sender]);
        require (bank_d1[bank_address].bal > amount );
                                                       
        NewSPToken(_token).transferFrom(msg.sender,bank_address,tokens);
        bank_d1[msg.sender].bal += amount;  //  msg.sender.transfer(msg.value);
        bank_d1[bank_address].bal -= amount;
        ln_get[msg.sender][ln_get_count[msg.sender]].bank_address = bank_address;
        ln_get[msg.sender][ln_get_count[msg.sender]].amount = amount;
        ln_get[msg.sender][ln_get_count[msg.sender]].months=year*12;
        ln_get[msg.sender][ln_get_count[msg.sender]].time=now;
        ln_get[msg.sender][ln_get_count[msg.sender]].tcount=tokens;
        ln_get[msg.sender][ln_get_count[msg.sender]].last_setl_time=now;
        ln_get[msg.sender][ln_get_count[msg.sender]].installment=(amount)/(year*12);
        ln_get[msg.sender][ln_get_count[msg.sender]].bal_ln = amount;
        ln_get[msg.sender][ln_get_count[msg.sender]].token_address=_token;
        ln_pro[bank_address][ln_pro_count[bank_address]].bank_address = msg.sender;
        ln_pro[bank_address][ln_pro_count[bank_address]].amount = amount;
        ln_pro[bank_address][ln_pro_count[bank_address]].months=year*12;
        ln_pro[bank_address][ln_pro_count[bank_address]].tokens=tokens;
        ln_pro[bank_address][ln_pro_count[bank_address]].time=now;
        
        ln_pro_count[bank_address]++;
        ln_get_count[msg.sender]++;
       // return(bank_d1[bank_address].tokencount,bank_d1[msg.sender].tokencount);
    }
    function balanceOftoken(address _token) public view returns(uint){
        return NewSPToken(_token).balanceOf(msg.sender);
    }
    
    function settlement(uint ln_id) public returns(uint256,uint256)
    {
        uint temp_count=ln_get[msg.sender][ln_id].count;
        uint temp_month=ln_get[msg.sender][ln_id].months;
        uint temp_bal_ln=ln_get[msg.sender][ln_id].bal_ln;
        uint temp_ins=ln_get[msg.sender][ln_id].installment;
        uint temp_last=ln_get[msg.sender][ln_id].last_setl_time + 20 seconds;//30 days;
        address temp_bank_address=ln_get[msg.sender][ln_id].bank_address;
        //uint temp_tcount=ln_get[msg.sender][ln_id].tcount;
        address _token=ln_get[msg.sender][ln_id].token_address;
        uint tokens=ln_pro[temp_bank_address][ln_pro_count[temp_bank_address]].tokens;
        
        if(temp_count<temp_month-1){
        require((temp_last)<=now);
        
        uint intr=bank_d1[temp_bank_address].loan_interst;
        uint amont=( temp_bal_ln * (intr/100) ) /100;
        
        require(amont+temp_ins<=bank_d1[msg.sender].bal);
        
        bank_d1[msg.sender].bal -= amont+temp_ins;
        bank_d1[temp_bank_address].bal += amont+temp_ins;
        
        ln_get[msg.sender][ln_id].last_setl_time = temp_last;//30 days;
        ln_get[msg.sender][ln_id].bal_ln-=temp_ins;
        ln_get[msg.sender][ln_id].count++;
        
        NewSPToken(_token).transferFrom(temp_bank_address,msg.sender,tokens);
        
        //require( ln_get[msg.sender][ln_id].count==12);
        // bank_d1[msg.sender].tokencount-= bank_d1[msg.sender].tokencount;
        }
        /*else if(temp_count==temp_month-1){
          bank_d1[msg.sender].tokencount += temp_tcount ;
       bank_d1[temp_bank_address].tokencount -= temp_tcount ;                 
         return( bank_d1[msg.sender].tokencount,bank_d1[temp_bank_address].tokencount );*
            
        }*/
    } 
    
}
