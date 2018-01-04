module Models1
{
    Model : 
    {
        Id : Integer64 = AutoNumber();
        Name : Text;
        Length : Integer64;
    }* where identity Id;   
}