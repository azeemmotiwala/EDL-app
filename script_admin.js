document.addEventListener("DOMContentLoaded", function() {
    const emailInput = document.getElementById("email");
    const errorContainer = document.createElement("div");
    errorContainer.className = "error-message";
    emailInput.parentNode.insertBefore(errorContainer, emailInput.nextSibling);

    // Add event listener to the submit button
    document.querySelector("button[type='submit']").addEventListener("click", async function(event) {
        event.preventDefault(); // Prevent the default form submission behavior

        // Get the entered email value
        const email = emailInput.value;

        // Validate email format
        if (!isValidEmail(email)) {
            showError("Please enter a valid email address.");
            return;
        }

        try {
            // Make POST request to the API with email in the request body
            const response = await fetch('http://192.168.43.144:8000/add-email', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ email: email })
            });

            if (response.ok) {
                // API call successful
                showSuccess("Email added successfully.");
                console.log("Email added successfully:", email);
                
                // Clear success message after 3 seconds
                setTimeout(() => {
                    clearSuccessMessage();
                }, 3000);
                
                return;
            } else {
                // API call failed
                showError("Failed to add email. Please try again later.");
            }
        } catch (error) {
            // Handle any network or server errors
            showError("An unexpected error occurred. Please try again later.");
            console.error('Error:', error);
        }
    });

    // Function to validate email format
    function isValidEmail(email) {
        // Regular expression for basic email validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    // Function to display error message
    function showError(message) {
        // Set error message content
        errorContainer.textContent = message;
    }

    // Function to display success message
    function showSuccess(message) {
        const successMessage = document.createElement("div");
        successMessage.className = "success-message";
        successMessage.textContent = message;
        document.getElementById("login-container").appendChild(successMessage);
    }

    // Function to clear success message
    function clearSuccessMessage() {
        const successMessage = document.querySelector(".success-message");
        if (successMessage) {
            successMessage.remove();
        }
    }
});


document.getElementById("go-home-btn").addEventListener("click", function() {
    window.location.href = "home.html"; // Redirect to the home page
});