using MailKit.Net.Smtp;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using MimeKit;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Utilities {

    public class EmailSender : IEmailSender {

        private readonly IEmailConfiguration _emailConfiguration;
        private readonly IWebHostEnvironment _env;

        public EmailSender(IEmailConfiguration emailConfiguration, IWebHostEnvironment env) {
            _emailConfiguration = emailConfiguration;
            _env = env;
        }

        public async Task SendEmailAsync(string email, string subject, string htmlMessage) {
            try {
                var message = new MimeMessage();
                message.From.Add(
                    new MailboxAddress(
                        _emailConfiguration.SenderName,
                        _emailConfiguration.SenderEmail
                    )
                );
                message.To.Add(new MailboxAddress(email, email));
                message.Subject = subject;
                message.Body = new TextPart("html") {
                    Text = htmlMessage
                };

                using (var client = new SmtpClient()) {
                    client.ServerCertificateValidationCallback = (s, c, h, e) => true;
                    if (_env.IsDevelopment()) {
                        await client.ConnectAsync(_emailConfiguration.SmtpServer, _emailConfiguration.SmtpPort, true);
                    }
                    else {
                        await client.ConnectAsync(_emailConfiguration.SmtpServer);
                    }

                    await client.AuthenticateAsync(_emailConfiguration.SmtpUsername, _emailConfiguration.SmtpPassword);
                    await client.SendAsync(message);
                    await client.DisconnectAsync(true);
                }
            }
            catch (Exception e) {
                throw new InvalidOperationException(e.Message);
            }
            
        }
    }
}
