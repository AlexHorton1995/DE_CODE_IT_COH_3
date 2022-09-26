using System.Runtime.Serialization;
using static Dapper.SqlMapper;

namespace CustomerApi.Models
{
    [DataContract]
    public class CustomerModel
    {
        public CustomerModel()
        {
            CustomerID = 0;
            OrderNumber = string.Empty;
            StoreID = string.Empty;
            OrderDate = DateTime.Today;
            TitleID = string.Empty;
            FirstName = string.Empty;
            LastName = string.Empty;
            Address1 = string.Empty;
            Address2 = string.Empty;
            City = string.Empty;
            State = string.Empty;
            Zip = string.Empty;
            Phone = string.Empty;
            EMail = string.Empty;
        }

        public int CustomerID { get; set; }
        public string OrderNumber { get; set; }
        public string StoreID { get; set; }
        public DateTime OrderDate { get; set; }
        public string TitleID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }
        public string Phone { get; set; }
        public string EMail { get; set; }


    }
}
