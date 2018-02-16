pragma solidity ^0.4.18;
contract Librarybook
{   address internal admin;
    function Librarybook()
    {
        admin=msg.sender;
    }
    struct lib_books
    {
        string bookname;
        string bookAUname;
        uint available;
    }
    struct student
    {
        string sname;
        string bname;
        uint sbooks;
        uint fineamount;
        bool check;
    }
    struct timing
    {
        uint book_gettime;
        uint book_returntime;
    }
    modifier onlybyadmin()
    {   
        require(msg.sender==admin);
    _;
    }
    
    mapping(uint=>student) public studentdetail;
    uint[] internal studentids;
    mapping(uint=>lib_books) public bookdetail;
    uint[] internal bookids;
    mapping(uint=>mapping(uint=>timing)) timefor;
    function setstudentids(uint sid,string sn) public payable
    {
        studentdetail[sid].sname=sn;
        studentids.push(sid);
    }
        function Setbooks(uint ISBnumber,string _bname,string _baname,uint _avail) public payable onlybyadmin
    {
        bookdetail[ISBnumber].bookname=_bname;
        bookdetail[ISBnumber].bookAUname=_baname;
        bookdetail[ISBnumber].available=_avail;
        bookids.push(ISBnumber);
        
    }
    function Getbooks(uint sid,uint isbn,uint gettime) public onlybyadmin
    { 
    
        require(!studentdetail[sid].check);
        bookdetail[isbn].available--;
        studentdetail[sid].bname=bookdetail[isbn].bookname;
        studentdetail[sid].sbooks++;
        studentdetail[sid].check=true;
        timefor[isbn][sid].book_gettime=gettime;
    }
    function Returnbooks(uint sid,uint isbn,uint book_returntime) public payable onlybyadmin
    {
       
        if(studentdetail[sid].check)
        {
            bookdetail[isbn].available++;
            studentdetail[sid].sbooks--;
            delete studentdetail[sid].bname;
            studentdetail[sid].check=false;
            timefor[isbn][sid].book_returntime=book_returntime;
        } 
    }
    function Fineamount(uint isbn,uint sid) public view returns(uint)
    {
        
        uint ch=timefor[isbn][sid].book_gettime-timefor[isbn][sid].book_returntime;
        uint days_count=(((ch/60)/60)/24);
        if(days_count>7)
        {
             return studentdetail[sid].fineamount=(days_count-0)*2;
            
        }
        else
        {
            return 0;
        }
    }
    
        
    
    function BookList() public view returns(uint[])
    {
        return bookids;
    }
   function StudentList() public view returns(uint[])
    {
       return studentids;
    }
}
