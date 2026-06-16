=== Project 05 - WhatsApp Maintenance Enhancement ===

STUDENT: Irfan Ahmed

----------------------------------------
PART 1: IMPLEMENTATION
----------------------------------------
A new class "WhatsAppService" was created that implements the existing NotificationMedium interface.

The send(String message) method prints:
[WhatsApp] Sending message: message text

No changes were made to:
- AlertSystem.java
- NotificationMedium.java

The system continues to use ArrayList of String to store logs, proving that inherited behavior through composition works correctly.

----------------------------------------
PART 2: GENERATIVE AI & REFINEMENT
----------------------------------------

Prompt used:
"Generate a Java class named WhatsAppService that implements an existing interface NotificationMedium with method send(String message). The method should print '[WhatsApp] Sending message: message'."

Verification:
- Ensured method signature EXACTLY matches:
  void send(String message)
- Did not change the interface or existing classes
- Followed Open-Closed Principle

Adjustments made:
- Added proper JavaDoc comments
- Verified output format matches assignment requirements

----------------------------------------
PART 3: VERIFICATION
----------------------------------------

Commands used:

javac *.java
java MainApp

Results:
- Email, SMS, and WhatsApp all work correctly
- System switches mediums at runtime using setMedium()
- Logs are stored correctly

----------------------------------------
MAINTENANCE PROOF
----------------------------------------

The AlertSystem class was NOT modified.
New functionality was added by plugging in WhatsAppService.

This demonstrates:
- Composition
- SOLID (Open-Closed Principle)
- Real-world maintenance approach

