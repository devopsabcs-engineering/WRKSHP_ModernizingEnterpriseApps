using System.ComponentModel.DataAnnotations;

namespace SampleWebApplicationCore.Models
{
    public class AccessLog
    {
        [Key]
        public int VisitId { get; set; }
        public String PageName { get; set; }
        public String AccessDate { get; set; }
    }
}
