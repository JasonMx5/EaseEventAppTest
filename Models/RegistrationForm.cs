using System.ComponentModel.DataAnnotations;

namespace EventEaseApp.Models;

public class RegistrationForm
{
    [Required(ErrorMessage = "Full name is required.")]
    [StringLength(100, MinimumLength = 2, ErrorMessage = "Full name must be between 2 and 100 characters.")]
    [RegularExpression(@"^[\p{L} .'-]+$", ErrorMessage = "Full name can contain only letters, spaces, apostrophes, periods, and hyphens.")]
    public string FullName { get; set; } = string.Empty;

    [Required(ErrorMessage = "Email is required.")]
    [EmailAddress(ErrorMessage = "Please enter a valid email address.")]
    public string Email { get; set; } = string.Empty;
}
