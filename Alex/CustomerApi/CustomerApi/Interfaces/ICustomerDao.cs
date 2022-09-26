using CustomerApi.Models;

namespace CustomerApi.Interfaces
{
    public interface ICustomerDao
    {
        public Task<IEnumerable<CustomerModel>> GetCustomersById(int custID);
        public Task<IEnumerable<CustomerModel>> GetAllCustomers();
        public Task<IEnumerable<CustomerModel>> UpdateCustomer(CustomerModel model);
    }
}
