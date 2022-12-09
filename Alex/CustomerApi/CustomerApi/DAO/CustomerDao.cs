using CustomerApi.Context;
using CustomerApi.Interfaces;
using CustomerApi.Models;
using Dapper;

namespace CustomerApi.DAO
{
    public class CustomerDao : ICustomerDao
    {
        private readonly DapperContext _context;

        public CustomerDao(DapperContext context)
        {
            _context = context;
        }

        /// <summary>
        /// GetCustomersById
        /// </summary>
        /// <param name="custID"></param>
        /// <returns>Returns a specific customer.</returns>
        public async Task<IEnumerable<CustomerModel>> GetCustomersById(int custID)
        {
            var query = @"SELECT 
	                        cust_id CustomerID,
	                        ord_num OrderNumber,
	                        stor_id StoreID,
	                        ord_date OrderDate,
	                        title_id TitleID,
	                        cust_fname FirstName,
	                        cust_lname LastName, 
	                        cust_add1 Address1, 
	                        cust_add2 Address2, 
	                        cust_city City,
	                        cust_state [State],
	                        cust_zip Zip,
	                        cust_phone Phone,
	                        cust_email EMail 
                        FROM [dbo].[customers] (NOLOCK) WHERE cust_id = @CustomerID";

            using (var connection = _context.CreateConnection())
            {
                connection.Open();

                var data = await connection.QueryAsync<CustomerModel>(query, new { CustomerID = custID });
                return data.ToList();
            }
        }

        /// <summary>
        /// GetAllCustomers
        /// </summary>
        /// <returns>Returns All Customers, sorted by the Customer ID</returns>
        public async Task<IEnumerable<CustomerModel>> GetAllCustomers()
        {
            var query = @"SELECT 
	                        cust_id CustomerID,
	                        ord_num OrderNumber,
	                        stor_id StoreID,
	                        ord_date OrderDate,
	                        title_id TitleID,
	                        cust_fname FirstName,
	                        cust_lname LastName, 
	                        cust_add1 Address1, 
	                        cust_add2 Address2, 
	                        cust_city City,
	                        cust_state [State],
	                        cust_zip Zip,
	                        cust_phone Phone,
	                        cust_email EMail 
                        FROM [dbo].[customers] (NOLOCK) 
                        ORDER BY cust_id ASC";

            using (var connection = _context.CreateConnection())
            {
                connection.Open();

                var data = await connection.QueryAsync<CustomerModel>(query);
                return data.ToList();
            }
        }

        /// <summary>
        /// UpdateCustomer
        /// </summary>
        /// <param name="model"></param>
        /// <returns>Updated customer.  Looks up the customer first and if not existing, will insert a new customer.</returns>
        public async Task<IEnumerable<CustomerModel>> UpdateCustomer(CustomerModel model)
        {
            IEnumerable<CustomerModel> data = await this.GetCustomersById(model.CustomerID).ConfigureAwait(false);

            //add a generic function here to compare the returned model with the new one

            if (data.Count() == 1)
            {
                //A row exists in the table, we need to do an update
                var updateData = await this.UpdateExistingCustomer(data.FirstOrDefault(), model).ConfigureAwait(false);
                return updateData;
            }
            else
            {
                //A row does NOT exist in the table, we need to do an insert 
                var newData = await this.InsertNewCustomer(data).ConfigureAwait(false);
                return newData;
            }
        }

        private async Task<IEnumerable<CustomerModel>> InsertNewCustomer(IEnumerable<CustomerModel> models)
        {
            var query = @"INSERT INTO [dbo].[customers]
           ([ord_num],[stor_id],[ord_date],[title_id],[cust_fname],[cust_lname]
            ,[cust_add1],[cust_add2],[cust_city],[cust_state],[cust_zip],[cust_phone],[cust_email])
           VALUES(@OrderNumber, @StoreID, @OrderDate, @TitleID, @CFirstName, @CLastName, @CAddress1,
                    @CAddress2, @City, @State, @Zip, @Phone, @Email)";

            using (var connection = _context.CreateConnection())
            {
                connection.Open();

                foreach (var model in models)
                {
                    var data = await connection.ExecuteAsync(query, new
                    {
                        OrderNumber = model.OrderNumber,
                        StoreID = model.StoreID,
                        OrderDate = model.OrderDate,
                        TitleID = model.TitleID,
                        CFirstName = model.FirstName,
                        CLastName = model.LastName,
                        CAddress1 = model.Address1,
                        CAddress2 = model.Address2,
                        City = model.City,
                        State = model.State,
                        Zip = model.Zip,
                        Phone = model.Phone,
                        Email = model.EMail
                    });
                }
                return await this.GetCustomersById(models.FirstOrDefault().CustomerID).ConfigureAwait(false);
            }
        }

        private async Task<IEnumerable<CustomerModel>> UpdateExistingCustomer(CustomerModel model, CustomerModel newModel)
        {
            var query = @"UPDATE [dbo].[customers]
                        SET [ord_num] = CASE WHEN ISNULL(@OrderNumber, '') = '' THEN [ord_num] ELSE @OrderNumber END,
	                        [stor_id] = CASE WHEN ISNULL(@StoreID, '') = '' THEN [stor_id] ELSE @StoreID END,
	                        [ord_date] = CASE WHEN ISNULL(@OrderDate, '') = '' THEN [ord_date] ELSE @OrderDate END,
	                        [title_id] = CASE WHEN ISNULL(@TitleID, '') = '' THEN [title_id] ELSE @TitleID END,
	                        [cust_fname] = CASE WHEN ISNULL(@CFirstName, '') = '' THEN [cust_fname] ELSE @CFirstName END,
	                        [cust_lname] = CASE WHEN ISNULL(@CLastName, '') = '' THEN [cust_lname] ELSE @CLastName END,
	                        [cust_add1] = CASE WHEN ISNULL(@CAddress1, '') = '' THEN [cust_add1] ELSE @CAddress1 END,
	                        [cust_add2] = CASE WHEN ISNULL(@CAddress2, '') = '' THEN [cust_add2] ELSE @CAddress2 END,
	                        [cust_city] = CASE WHEN ISNULL(@City, '') = '' THEN [cust_city] ELSE @City END,
	                        [cust_state] = CASE WHEN ISNULL(@State, '') = '' THEN [cust_state] ELSE @State END,
	                        [cust_zip] = CASE WHEN ISNULL(@Zip, '') = '' THEN [cust_zip] ELSE @Zip END,
	                        [cust_phone] = CASE WHEN ISNULL(@Phone, '') = '' THEN [cust_phone] ELSE @Phone END,
	                        [cust_email] = CASE WHEN ISNULL(@Email, '') = '' THEN [cust_email] ELSE @Email END
                        WHERE @CustomerID = cust_id";

            using (var connection = _context.CreateConnection())
            {
                connection.Open();

                    var data = await connection.ExecuteAsync(query, new
                    {
                        CustomerID = Extensions.FieldIsSame(model.CustomerID, newModel.CustomerID) ? model.CustomerID : newModel.CustomerID,
                        OrderNumber = Extensions.FieldIsSame(model.OrderNumber, newModel.OrderNumber) ? model.OrderNumber : newModel.OrderNumber,
                        StoreID = Extensions.FieldIsSame(model.StoreID, newModel.StoreID) ? model.StoreID : newModel.StoreID,
                        OrderDate = Extensions.FieldIsSame(model.OrderDate, newModel.OrderDate) ? model.OrderDate : newModel.OrderDate,
                        TitleID = Extensions.FieldIsSame(model.TitleID, newModel.TitleID) ? model.TitleID : newModel.TitleID,
                        CFirstName = Extensions.FieldIsSame(model.FirstName, newModel.FirstName) ? model.FirstName : newModel.FirstName,
                        CLastName = Extensions.FieldIsSame(model.LastName, newModel.LastName) ? model.LastName : newModel.LastName,
                        CAddress1 = Extensions.FieldIsSame(model.Address1, newModel.Address1) ? model.Address1 : newModel.Address1,
                        CAddress2 = Extensions.FieldIsSame(model.Address2, newModel.Address2) ? model.Address2 : newModel.Address2,
                        City = Extensions.FieldIsSame(model.City, newModel.City) ? model.City : newModel.City,
                        State = Extensions.FieldIsSame(model.State, newModel.State) ? model.State : newModel.State,
                        Zip = Extensions.FieldIsSame(model.Zip, newModel.Zip) ? model.Zip : newModel.Zip,
                        Phone = Extensions.FieldIsSame(model.Phone, newModel.Phone) ? model.Phone : newModel.Phone,
                        Email = Extensions.FieldIsSame(model.EMail, newModel.EMail) ? model.EMail : newModel.EMail
                    });

                return await this.GetCustomersById(model.CustomerID).ConfigureAwait(false);

            }
        }

    }
}
