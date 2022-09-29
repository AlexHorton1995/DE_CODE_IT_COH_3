using System.Data;
using System.Runtime.CompilerServices;

namespace IntakeFIleProcessing
{


    internal class Program : IDisposable
    {
        IDao AppDao { get; set; }
        static FileInfo OutFile { get; set; }
        Dictionary<int, string?> Identities { get; set; }
        Dictionary<int, string?> OutreachTypes { get; set; }
        Dictionary<int, string?> ExpLevels { get; set; }
        Dictionary<int, string?> Occupations { get; set; }
        Dictionary<int, string?> PersonalDesc { get; set; }
        Dictionary<int, string?> TechAreas { get; set; }
        Dictionary<int, string?> ShirtSizes { get; set; }
        Dictionary<int, string?> PLanguages { get; set; }
        static Program() { }

        public Program()
        {
            this.Identities = new Dictionary<int, string?>() { };
            this.OutreachTypes = new Dictionary<int, string?>() { };
            this.ExpLevels = new Dictionary<int, string?>() { };
            this.Occupations = new Dictionary<int, string?>() { };
            this.PersonalDesc = new Dictionary<int, string?>() { };
            this.TechAreas = new Dictionary<int, string?>() { };
            this.ShirtSizes = new Dictionary<int, string?>() { };
            this.PLanguages = new Dictionary<int, string?>() { };
        }

        #region Static
        public static int Main(string[] args)
        {
            try
            {
                using (var dao = new DAO())
                using (var instance = new Program())
                {
                    instance.AppDao = dao;
                    instance.Run(args);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                return 1;
            }

            return 0;
        }
        #endregion

        public void Run(string[] args)
        {
            //check for files first
            if (CheckFileDependencies(args))
            {
                //populate dictionaries
                PopulateDicts();

                //create container table
                var dTable = CreateBulkTable();

                //read in file and populate datatable
                ReadFile(dTable);

                //copy up to database
                this.AppDao.BulkCopy(dTable);
            }
            else
            {

            }
        }

        public bool CheckFileDependencies(string[] args)
        {
            var wDirectory = @"C:\IntakeFiles";
            var wDirectoryNew = @"C:\IntakeFiles\NewFiles";
            var wDirectoryOld = @"C:\IntakeFiles\ProcessedFiles";
            var fileName = args[0];

            try
            {

                //look for main directory
                if (!Directory.Exists(wDirectory))
                    Directory.CreateDirectory(wDirectory);

                Directory.SetCurrentDirectory(wDirectory);

                //look for file directories
                if (!Directory.Exists(wDirectoryOld))
                    Directory.CreateDirectory(wDirectoryOld);

                if (!Directory.Exists(wDirectoryNew))
                    Directory.CreateDirectory(wDirectoryNew);

                FileInfo newFile = new FileInfo(wDirectoryNew + @$"\{fileName}");

                if (newFile.Exists)
                {
                    newFile.CopyTo(wDirectoryOld + @$"\{fileName}_{DateTime.Now.ToString("MMddYYHHmmss")}");
                }
                else
                {
                    return false;
                }

                OutFile = newFile;
                return true;
            }
            catch (Exception)
            {
                return false;
            }

        }

        public void PopulateDicts()
        {
            this.Identities = this.AppDao.GetIdentity();
            this.OutreachTypes = this.AppDao.GetOutreachTypes();
            this.ExpLevels = this.AppDao.GetLvlExperiences();
            this.Occupations = this.AppDao.GetOccupations();
            this.PersonalDesc = this.AppDao.GetPersonalDesc();
            this.TechAreas = this.AppDao.GetTechAreas();
            this.ShirtSizes = this.AppDao.GetShirtSizes();
            this.PLanguages = this.AppDao.GetProgrammingLangs();
        }

        public DataTable CreateBulkTable()
        {
            DataTable dt = new DataTable("#TempCBIntake");
            dt.Columns.AddRange(
                new DataColumn[]
                {
                    new DataColumn("t_member_date", typeof(DateTime)) {AllowDBNull = false, DefaultValue = DateTime.Today},
                    new DataColumn("t_first_name", typeof(string)) {AllowDBNull = false, MaxLength = 30},
                    new DataColumn("t_last_name", typeof(string)) {AllowDBNull = false, MaxLength = 30},
                    new DataColumn("t_email", typeof(string)) {AllowDBNull = true, MaxLength = 60},
                    new DataColumn("t_phone", typeof(string)) {AllowDBNull = true, MaxLength = 15},
                    new DataColumn("t_address1", typeof(string)) {AllowDBNull = false, MaxLength = 35},
                    new DataColumn("t_address2", typeof(string)) {AllowDBNull = false, MaxLength = 35},
                    new DataColumn("t_city", typeof(string)) {AllowDBNull = false, MaxLength = 23},
                    new DataColumn("t_state", typeof(string)) {AllowDBNull = false, MaxLength = 2},
                    new DataColumn("t_zip", typeof(string)) {AllowDBNull = false, MaxLength = 6},
                    new DataColumn("t_country", typeof(string)) {AllowDBNull = false, MaxLength = 3, DefaultValue = "USA"},
                    new DataColumn("t_dob", typeof(DateTime)) {AllowDBNull = false},
                    new DataColumn("t_self_identify", typeof(int)) {AllowDBNull = false, DefaultValue = 1},
                    new DataColumn("t_self_description", typeof(int)) {AllowDBNull = false, DefaultValue = 1},
                    new DataColumn("t_outreach_type", typeof(int)) {AllowDBNull = false, DefaultValue = 1},
                    new DataColumn("t_occupation", typeof(int)) {AllowDBNull = false, DefaultValue = 1},
                    new DataColumn("t_occupation_other", typeof(string)) {AllowDBNull = false, MaxLength = 500},
                    new DataColumn("t_job_seeking", typeof(bool)) {AllowDBNull = false, DefaultValue = false},
                    new DataColumn("t_exp_level", typeof(int)) {AllowDBNull = false, DefaultValue = 1},
                    new DataColumn("t_interest_area", typeof(int)) {AllowDBNull = false, DefaultValue = 9},
                    new DataColumn("t_interest_other", typeof(string)) {AllowDBNull = true, MaxLength = 500},
                    new DataColumn("t_programming_lang", typeof(int)) {AllowDBNull = false, DefaultValue = 319},
                    new DataColumn("t_programming_other", typeof(string)) {AllowDBNull = true, MaxLength = 500},
                    new DataColumn("t_shirt_size", typeof(int)) {AllowDBNull = false, DefaultValue = 1},
                }
                );
            return dt;
        }

        public void ReadFile(DataTable dTable)
        {
            string? line;
            using (StreamReader sr = new StreamReader(OutFile.FullName))
            {
                sr.ReadLine(); //read the first line which is a header row
                while ((line = sr.ReadLine()) != null)
                {
                    var arr = line.Split(',');


                    DataRow row = dTable.NewRow();
                    DateTime.TryParse(arr[10], out DateTime dob);
                    DateTime.TryParse(arr[23], out DateTime mDate);
                    row["t_member_date"] = mDate;
                    row["t_first_name"] = arr[0].Trim();
                    row["t_last_name"] = arr[1].Trim();
                    row["t_email"] = arr[2].Trim();
                    row["t_phone"] = arr[3].Trim();
                    row["t_address1"] = arr[4].Trim();
                    row["t_address2"] = arr[5].Trim();
                    row["t_city"] = arr[6].Trim();
                    row["t_state"] = arr[7].Trim();
                    row["t_zip"] = arr[8].Trim();
                    row["t_country"] = arr[9].Trim();
                    row["t_dob"] = dob;
                    row["t_self_identify"] = this.Identities.Where(x => x.Value.Contains(arr[11])).Select(y => y.Key).FirstOrDefault();
                    row["t_self_description"] = this.PersonalDesc.Where(x => x.Value.Contains(arr[12])).Select(y => y.Key).FirstOrDefault();
                    row["t_outreach_type"] = this.OutreachTypes.Where(x => x.Value.Contains(arr[13])).Select(y => y.Key).FirstOrDefault();
                    row["t_occupation"] = this.Occupations.Where(x => x.Value.Contains(arr[14])).Select(y => y.Key).FirstOrDefault();
                    row["t_occupation_other"] = arr[15];
                    row["t_job_seeking"] = arr[16] == "Yes" ? true : false;
                    row["t_exp_level"] = this.ExpLevels.Where(x => x.Value.Contains(arr[17])).Select(y => y.Key).FirstOrDefault();
                    row["t_interest_area"] = this.TechAreas.Where(x => x.Value.Contains(arr[14])).Select(y => y.Key).FirstOrDefault(); 
                    row["t_interest_other"] = arr[19].Trim();
                    row["t_programming_lang"] = this.PLanguages.Where(x => x.Value.Contains(arr[20])).Select(y => y.Key).FirstOrDefault();
                    row["t_programming_other"] = arr[21].Trim();
                    row["t_shirt_size"] = this.ShirtSizes.Where(x => x.Value.Contains(arr[22])).Select(y => y.Key).FirstOrDefault();
                    dTable.Rows.Add(row);
                }
            }
        }

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
        // ~Program()
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