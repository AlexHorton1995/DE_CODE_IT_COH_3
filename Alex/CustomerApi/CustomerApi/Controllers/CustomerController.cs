using CustomerApi.Interfaces;
using CustomerApi.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;


namespace CustomerApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CustomerController : ControllerBase
    {
        private readonly ICustomerDao Dao;

        public CustomerController(ICustomerDao custDao)
        {
            Dao = custDao;
        }

        [HttpGet("[action]")]
        public async Task<ActionResult<IEnumerable<CustomerModel>>> GetAllCustomers()
        {
            try
            {
                var data = await Dao.GetAllCustomers().ConfigureAwait(false);

                return Ok(data);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("[action]")]
        public async Task<ActionResult<IEnumerable<CustomerModel>>> GetCustomerByID(int custID)
        {
            try
            {
                var data = await Dao.GetCustomersById(custID).ConfigureAwait(false);

                return Ok(data);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpPost("[action]")]
        public async Task<ActionResult<IEnumerable<CustomerModel>>> UpdateOrCreateCustomer(CustomerModel model)
        {
            try
            {
                var data = await Dao.UpdateCustomer(model).ConfigureAwait(false);

                return Ok(data);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }


    }
}
