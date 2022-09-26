using Microsoft.Data.SqlClient;
using System.Data;
using Microsoft.Extensions.Configuration;

namespace CustomerApi.Context
{
    public class DapperContext
    {
        private readonly IConfiguration _configuration;
        private readonly string _connectionString;

        public DapperContext(IConfiguration configuration)
        {
            _configuration = configuration;
#if DEBUG
            _connectionString = _configuration.GetConnectionString("develop");
#else
            _connectionString = _configuration.GetConnectionString("prod");
#endif
        }

        public IDbConnection CreateConnection() => new SqlConnection(_connectionString);
    }
}
