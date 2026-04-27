# 🔐 Security Fix: Compromised Secrets

## 🚨 IMMEDIATE ACTIONS REQUIRED

Your secrets have been compromised because they were committed to GitHub. Follow these steps NOW:

---

## Step 1: Rotate ALL Compromised Secrets

### 1.1 MongoDB Atlas Password
1. Login to [MongoDB Atlas](https://cloud.mongodb.com)
2. Go to **Database Access** → Select your user
3. Click **Edit** → **Edit Password**
4. Generate a new strong password
5. Save the new password
6. Update your connection string with the new password

### 1.2 JWT Secret
Generate a new random secret:

**On your local machine:**
```bash
openssl rand -base64 32
```

Copy the output - this is your new JWT secret.

### 1.3 Mailtrap Password
1. Login to [Mailtrap](https://mailtrap.io)
2. Go to **Email Testing** → **Inboxes** → Select your inbox
3. Click **SMTP Settings**
4. Click **Regenerate Password**
5. Copy the new password

---

## Step 2: Update .env File

Open your `.env` file and replace ALL placeholders with your NEW credentials:

```bash
# MongoDB - Use NEW password you just created
MONGODB_AUTH_URI=mongodb+srv://YOUR_USERNAME:NEW_PASSWORD@cluster.mongodb.net/js_auth_service?retryWrites=true&w=majority
MONGODB_CATEGORY_URI=mongodb+srv://YOUR_USERNAME:NEW_PASSWORD@cluster.mongodb.net/js_category_service?retryWrites=true&w=majority
MONGODB_PRODUCT_URI=mongodb+srv://YOUR_USERNAME:NEW_PASSWORD@cluster.mongodb.net/js_product_service?retryWrites=true&w=majority
MONGODB_CART_URI=mongodb+srv://YOUR_USERNAME:NEW_PASSWORD@cluster.mongodb.net/js_cart_service?retryWrites=true&w=majority
MONGODB_ORDER_URI=mongodb+srv://YOUR_USERNAME:NEW_PASSWORD@cluster.mongodb.net/js_order_service?retryWrites=true&w=majority

# JWT - Use the output from: openssl rand -base64 32
JWT_SECRET=paste-your-new-secret-here

# Mailtrap - Use NEW password
MAIL_HOST=sandbox.smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=your-mailtrap-username
MAIL_PASSWORD=your-new-mailtrap-password
```

---

## Step 3: Remove Secrets from Git History

### Option A: If you just pushed secrets (RECOMMENDED)

1. **Delete `.env` from GitHub immediately:**
   ```bash
   git rm --cached .env
   git commit -m "Remove .env file with secrets"
   git push origin main
   ```

2. **Add `.env` to `.gitignore`** (Already done - check your .gitignore file)

3. **Verify .env is ignored:**
   ```bash
   git status
   ```
   `.env` should NOT appear in the output.

### Option B: If secrets were committed a while ago

You need to rewrite Git history. Use BFG Repo Cleaner:

```bash
# Download BFG: https://rtyley.github.io/bfg-repo-cleaner/
java -jar bfg.jar --replace-text passwords.txt your-repo.git
cd your-repo.git
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git push origin --force --all
```

Create `passwords.txt` with your old secrets to remove them from history.

---

## Step 4: Secure Your GitHub Repository

### Enable Secret Scanning
1. Go to your GitHub repository
2. **Settings** → **Code security and analysis**
3. Enable **Secret scanning**
4. Enable **Push protection**

### Review Access
1. **Settings** → **Collaborators and teams**
2. Remove any unknown collaborators
3. Review team permissions

---

## Step 5: How to Clone on ByteXL Nimbus (Bash)

```bash
# Navigate to your workspace
cd /path/to/your/workspace

# Clone your repository
git clone https://github.com/YOUR_USERNAME/jkart.git

# Enter project directory
cd jkart

# Create .env file from template
cp .env.example .env

# Edit .env with your NEW credentials
nano .env
# OR
vim .env

# Deploy
bash deploy.sh
```

**Important:** The `.env` file will NOT be in the cloned repo because it's in `.gitignore`. You must create it manually on ByteXL Nimbus.

---

## Step 6: Verify .env is Protected

### Check .gitignore
Make sure your `.gitignore` contains:
```
# Environment variables with secrets
.env
!.env.example
```

### Verify .env won't be committed
```bash
# This should show .env as ignored
git check-ignore -v .env

# Try adding .env (should fail)
git add .env
# Should show: "The following paths are ignored by .gitignore"
```

---

## 🔒 Security Best Practices

### ✅ DO:
- Store `.env` file ONLY on deployment server
- Use `.env.example` with placeholder values in Git
- Rotate secrets every 90 days
- Use strong, randomly generated secrets
- Enable GitHub secret scanning
- Use environment variables in CI/CD (GitHub Secrets)

### ❌ NEVER:
- Commit `.env` files to Git
- Share secrets in code or documentation
- Use the same secret across multiple environments
- Hardcode secrets in source code
- Share credentials via email/chat

---

## 🚀 Deployment Workflow (Secure)

### On Your Local Machine:
```bash
# 1. Clone repo
git clone https://github.com/YOUR_USERNAME/jkart.git
cd jkart

# 2. Create .env (NOT committed to Git)
cp .env.example .env
nano .env  # Add your real credentials

# 3. Commit code (without .env)
git add .
git commit -m "Update code"
git push origin main
```

### On ByteXL Nimbus:
```bash
# 1. Clone repo
git clone https://github.com/YOUR_USERNAME/jkart.git
cd jkart

# 2. Create .env manually
nano .env
# Paste your credentials here

# 3. Deploy
bash deploy.sh
```

---

## 📞 If You Suspect Unauthorized Access

1. **Change ALL passwords immediately**
2. **Revoke and regenerate ALL API keys**
3. **Check MongoDB Atlas logs** for unauthorized access
4. **Check Mailtrap logs** for suspicious email sends
5. **Enable 2FA** on all accounts
6. **Review Git commit history** for unauthorized changes

---

## ✅ Checklist

- [ ] MongoDB Atlas password changed
- [ ] JWT secret regenerated
- [ ] Mailtrap password regenerated
- [ ] `.env` file updated with new credentials
- [ ] `.env` removed from Git history
- [ ] `.env` added to `.gitignore`
- [ ] GitHub secret scanning enabled
- [ ] Tested deployment with new credentials
- [ ] Verified `.env` is not in repository

---

**🔐 Your secrets are now secure!**
