using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Utilities.EmailTemplate {
    public interface IEmailTemplateConfig {
        string GetAndFormatHtmlString(string fileName, string ime, string prezime, string confiramtionUrl);
    }
}
