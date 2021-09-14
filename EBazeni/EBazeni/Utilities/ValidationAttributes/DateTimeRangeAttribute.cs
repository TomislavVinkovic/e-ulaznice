using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Utilities.ValidationAttributes {
    public class DateTimeRangeAttribute: ValidationAttribute {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext) {
            value = (DateTime)value;
            if ((DateTime)value >= DateTime.UtcNow.Date) {
                return ValidationResult.Success;
            }
            else {
                return new ValidationResult("Datum mora biti današnji dan, ili neki datum u budućnosti!");
            }
        }
    }
}
