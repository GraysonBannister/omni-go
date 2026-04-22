# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x     | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please report it responsibly:

1. **DO NOT** create a public GitHub issue
2. Email the maintainers directly at: Bannister.grayson@gmail.com
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will:
- Acknowledge receipt within 48 hours
- Investigate and provide updates within 5 business days
- Coordinate a fix and disclosure timeline with you
- Credit you in the security advisory (unless you prefer anonymity)

## Security Best Practices for Users

### API Keys & Credentials
- Never hardcode API keys in the app
- Use secure storage for connection credentials
- Clear saved credentials when logging out
- Use HTTPS connections only

### QR Code Scanning
- Only scan QR codes from trusted sources
- Be aware that QR codes contain your API key
- If someone scans your QR code, regenerate the API key on desktop
- Don't share screenshots containing QR codes publicly

### Development
- Run `gitleaks detect --source .` before committing
- Use pre-commit hooks to prevent secret commits
- Review your code for accidental credential inclusion
