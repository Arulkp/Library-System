pragma solidity ^0.4.18;
import"./Register.sol";
contract fd
{   
     struct bank_user
      {
    uint  deposit_amount;
    uint deposit_time;
    uint scheme_finish_time;
    uint  year;
    uint annual_amounts;
    address to_account;
      }
      uint public deposit_count;
      uint[] public dep_banks;
      mapping(uint=>bank_user) public user;
      mapping(address=>uint) public balance;
      function deposit_request(uint id,address account,uint deposit_amount,uint year,address to,uint intesrst_rate) public 
      {   uint yr=(year*31556926);
          uint final_amount=deposit_amount+(intesrst_rate*deposit_amount/100);
          user[id].deposit_amount=deposit_amount;
          user[id].deposit_time=now;
          user[id].year=yr;
          user[id].annual_amounts=final_amount;
          user[id].scheme_finish_time=0;//(now+yr);
          user[id].to_account=to;
          dep_banks.push(id);
          deposit_count;
         dep_transfer(account,to,deposit_amount);
      }
      function FixedDepositAccounts() public view returns(uint[])
      {
          return dep_banks;
          }
      function deposit(uint amount)public 
      {
          balance[msg.sender]+=amount;
          
      }
      function dep_transfer(address account,address bank_address,uint amount) internal      //bank address 
      {   //require(balance[msg.sender]>=user[msg.sender].deposit_amount);
          balance[bank_address]+=amount;
          balance[account]-=amount;
       }
       function Return_dep_transfer(address account,address bank_address,uint amount) internal  //user address
       {
           balance[account]+=amount;
        balance[bank_address]-=amount;
       }
     function Return_amount(uint id,address account,address bank_address) public returns(string)
      {  
         if(now>user[id].scheme_finish_time)
         {
              Return_dep_transfer(account,bank_address,user[id].annual_amounts);
              deposit_count--;
              delete user[id];
              return "Amount transfered";
         }
         else
         {
             return "Scheme Time is Not Complete";
         }
          /*if(now<user[account].scheme_finish_time)
             {   
                uint penaulty=amount-(amount/100);
                 Return_dep_transfer(account,bank_address,penaulty);
             }*/
         
}
}

    
