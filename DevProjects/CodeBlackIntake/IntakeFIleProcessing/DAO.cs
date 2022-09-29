using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using Dapper;
using IntakeFIleProcessing.Properties;
using IntakeFIleProcessing.Models;

namespace IntakeFIleProcessing
{
    internal interface IDao
    {
        bool BulkCopy(DataTable table);

        /* Dictionaries */
        Dictionary<int, string?> GetIdentity();
        Dictionary<int, string?> GetOutreachTypes();
        Dictionary<int, string?> GetLvlExperiences();
        Dictionary<int, string?> GetOccupations();
        Dictionary<int, string?> GetPersonalDesc();
        Dictionary<int, string?> GetTechAreas();
        Dictionary<int, string?> GetShirtSizes();
        Dictionary<int, string?> GetProgrammingLangs();
    }

    internal class DAO : IDao, IDisposable
    {

        private readonly string? _connString = Environment.GetEnvironmentVariable("CodeBlackIntakeConnString");

        public bool BulkCopy(DataTable table)
        {
            try
            {

                using (SqlConnection conn = new SqlConnection(_connString))
                {
                    conn.Open();

                    //create the temp table over on the database
                    var val = conn.Execute(Resources.CreateTempIntake);

                    //bulk copy the local datatable over to the temp table
                    using (SqlBulkCopy bCopy = new SqlBulkCopy(conn))
                    {
                        bCopy.DestinationTableName = table.TableName;
                        try
                        {
                            bCopy.WriteToServer(table);
                        }
                        catch (Exception)
                        {
                            return false;
                        }
                    }

                    //insert the temp table contents into the live table
                    string sql = @"
                                    INSERT INTO [dbo].[CBRosterInfo]           
	                                    ([member_date],[first_name],[last_name],[email],[phone],[address1],[address2],[city],[state],[zip],[country],[dob]
	                                    ,[self_identify],[self_description],[outreach_type],[occupation],[occupation_other],[job_seeking]
	                                    ,[exp_level],[interest_area],[interest_other],[programming_lang],[programming_other],[shirt_size])
                                    SELECT [t_member_date],[t_first_name],[t_last_name],[t_email],[t_phone],[t_address1],[t_address2],[t_city],[t_state],[t_zip],[t_country],[t_dob]
                                        ,[t_self_identify],[t_self_description],[t_outreach_type],[t_occupation],[t_occupation_other],[t_job_seeking]
                                        ,[t_exp_level],[t_interest_area],[t_interest_other],[t_programming_lang],[t_programming_other],[t_shirt_size]
                                    FROM [#TempCBIntake] 
                                    LEFT OUTER JOIN [dbo].[CBRosterInfo] WITH (NOLOCK) ON [member_date] = [t_member_date]
                                    WHERE [member_key] IS NULL;
                                ";

                    var output = conn.Execute(sql);

                    //Drop the temp table
                    conn.Execute("DROP TABLE [#TempCBIntake];");
                }

                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        #region Dictionaries
        public Dictionary<int, string?> GetIdentity()
        {
            using (SqlConnection conn = new SqlConnection(_connString))
            {
                conn.Open();

                var data = conn.Query<GenderModel>(@"
                        SELECT gen_id GenID, gen_value GenType from [dbo].[gender]
                    ").ToDictionary(x => x.GenId, x => x.GenType);

                return data;
            }
        }

        public Dictionary<int, string?> GetOutreachTypes()
        {
            using (SqlConnection conn = new SqlConnection(_connString))
            {
                conn.Open();

                var data = conn.Query<OutreachModel>(@"
                        SELECT out_Key OutID, out_selection OutSelection from [dbo].[OutreachType]
                    ").ToDictionary(x => x.OutID, x => x.OutSelection);

                return data;
            }
        }

        public Dictionary<int, string?> GetLvlExperiences()
        {
            using (SqlConnection conn = new SqlConnection(_connString))
            {
                conn.Open();

                var data = conn.Query<ExperienceModel>(@"
                        SELECT Lexp_key ExperienceID, Lexp_Level ExperienceLevel from [dbo].[LvlExperience]
                    ").ToDictionary(x => x.ExperienceID, x => x.ExperienceLevel);

                return data;
            }
        }

        public Dictionary<int, string?> GetOccupations()
        {
            using (SqlConnection conn = new SqlConnection(_connString))
            {
                conn.Open();

                var data = conn.Query<OccModel>(@"
                        SELECT occ_key OccID, occ_selection OccSelection from [dbo].[Occupations]
                    ").ToDictionary(x => x.OccID, x => x.OccSelection);

                return data;
            }
        }

        public Dictionary<int, string?> GetPersonalDesc()
        {
            using (SqlConnection conn = new SqlConnection(_connString))
            {
                conn.Open();

                var data = conn.Query<PersDescModel>(@"
                        SELECT desc_key DescKey, desc_selection DescSelection from [dbo].[PersonalDesc]
                    ").ToDictionary(x => x.DescKey, x => x.DescSelection);

                return data;
            }
        }

        public Dictionary<int, string?> GetTechAreas()
        {
            using (SqlConnection conn = new SqlConnection(_connString))
            {
                conn.Open();

                var data = conn.Query<TechAreaModel>(@"
                        SELECT tech_id TechID, tech_area TechArea from [dbo].[TechAreas]
                    ").ToDictionary(x => x.TechID, x => x.TechArea);

                return data;
            }
        }

        public Dictionary<int, string?> GetShirtSizes()
        {
            using (SqlConnection conn = new SqlConnection(_connString))
            {
                conn.Open();

                var data = conn.Query<ShirtSizeModel>(@"
                        SELECT t_id SizeID, t_size Size from [dbo].[tshirt_size]
                    ").ToDictionary(x => x.SizeID, x => x.Size);

                return data;
            }
        }

        public Dictionary<int, string?> GetProgrammingLangs()
        {
            using (SqlConnection conn = new SqlConnection(_connString))
            {
                conn.Open();

                var data = conn.Query<ProgrammingModel>(@"
                        SELECT programming_id ProgID, prog_language ProgLanguage from [dbo].[ProgLanguages]
                    ").ToDictionary(x => x.ProgID, x => x.ProgLanguage);

                return data;
            }
        }
        #endregion
 
        #region Disposable
        private bool disposedValue;
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects)
                }

                // TODO: free unmanaged resources (unmanaged objects) and override finalizer
                // TODO: set large fields to null
                disposedValue = true;
            }
        }

        // // TODO: override finalizer only if 'Dispose(bool disposing)' has code to free unmanaged resources
        // ~DAO()
        // {
        //     // Do not change this code. Put cleanup code in 'Dispose(bool disposing)' method
        //     Dispose(disposing: false);
        // }

        public void Dispose()
        {
            // Do not change this code. Put cleanup code in 'Dispose(bool disposing)' method
            Dispose(disposing: true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
}
