using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Utilities {
    public interface IEmailConfiguration {

        string SmtpServer { get; }
		int SmtpPort { get; }
		string SmtpUsername { get; set; }
		string SmtpPassword { get; set; }
        public string SenderName { get; set; }
        public string SenderEmail { get; set; }
    }
}
