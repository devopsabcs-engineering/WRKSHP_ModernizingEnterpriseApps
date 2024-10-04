using System.ComponentModel.DataAnnotations;

namespace SampleWebApplicationCoreDemo.Models
{
    public class AccessLog
    {
        [Key]
        public int VisitId { get; set; }
        public string PageName { get; set; } = string.Empty;
        public string AccessDate { get; set; } = string.Empty;
    }
}
