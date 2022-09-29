using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IntakeFIleProcessing.Models
{
    /// <summary>
    /// Class that handles the intake file structure. Should mirror the database table.
    /// </summary>
    internal class IntakeFileModels
    {
        public DateTime MemberDate { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Email { get; set; }
        public string? Phone { get; set; }
        public string? Address1 { get; set; }
        public string? Address2 { get; set; }
        public string? City { get; set; }
        public string? State { get; set; }
        public string? Zip { get; set; }
        public string? Country { get; set; }
        public DateTime DOB { get; set; }
        public int SelfIdentify { get; set; }
        public int SelfDescription { get; set; }
        public int OutreachType { get; set; }
        public int Occupation { get; set; }
        public string? OccupationOther { get; set; }
        public bool IsSeekingJob { get; set; }
        public int ExperienceLevel { get; set; }
        public int InterestArea { get; set; }
        public string? InterestOther { get; set; }
        public int ProgrammingLanguage { get; set; }
        public string? ProgrammingOther { get; set; }
        public int TShirtSize { get; set; }
    }

    internal class GenderModel
    {
        public int GenId { get; set; }
        public string? GenType { get; set; }
    }

    internal class OutreachModel
    {
        public int OutID { get; set; }
        public string? OutSelection { get; set; }
    }

    internal class ExperienceModel
    {
        public int ExperienceID { get; set;}
        public string? ExperienceLevel { get; set; }
    }

    internal class OccModel
    {
        public int OccID { get; set; }
        public string? OccSelection { get; set; }
    }

    internal class PersDescModel
    {
        public int DescKey { get; set; }
        public string? DescSelection { get; set; }
    }

    internal class TechAreaModel
    {
        public int TechID { get; set; }
        public string? TechArea { get; set; }
    }

    internal class ShirtSizeModel
    {
        public int SizeID { get; set; }
        public string? Size { get; set; }
    }

    internal class ProgrammingModel
    {
        public int ProgID { get; set; }
        public string? ProgLanguage { get; set; }
    }
}
