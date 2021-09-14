using Microsoft.AspNetCore.Hosting;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Utilities.EmailTemplate {
    public class EmailTemplateConfig : IEmailTemplateConfig{

        private readonly IWebHostEnvironment _webHostEnviorment;

        public EmailTemplateConfig(IWebHostEnvironment webHostEnviorment) {
            _webHostEnviorment = webHostEnviorment;
        }

        public string GetAndFormatHtmlString(string fileName, string ime, string prezime, string confiramtionUrl) {
            var pathToTemplate = _webHostEnviorment.WebRootPath + Path.DirectorySeparatorChar.ToString() + "templates" + Path.DirectorySeparatorChar.ToString() + fileName;

            var htmlBody = "";

            using(StreamReader sr = System.IO.File.OpenText(pathToTemplate)){
                htmlBody = sr.ReadToEnd();
            }

            string messageBody = String.Format(
                htmlBody,
                ime,
                prezime,
                confiramtionUrl,
                confiramtionUrl
            );

            return messageBody;
        }
    }
}
