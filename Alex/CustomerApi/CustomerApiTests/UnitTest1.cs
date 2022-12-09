using CustomerApi.Models;
using CustomerApiTests.MockClasses;
using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CustomerApiTests
{
    [TestClass]
    public class UnitTest1
    {
        private MockCustomerModel mockModel { get; set; }

            
        [TestInitialize]
        public void TestInitialize()
        {
            this.mockModel = null;
        }

        [TestMethod]
        public void TestModels()
        {
            this.mockModel = new MockCustomerModel()
            {
                CustomerID = 0,
                Address1 = "Test"
            };

            CustomerModel expected = new CustomerModel()
            {
                CustomerID = 0,
                Address1 = "Test"
            };

            Assert.AreEqual(expected.CustomerID, this.mockModel.CustomerID);
            Assert.AreEqual(expected.Address1, this.mockModel.Address1);

        }
    }
}