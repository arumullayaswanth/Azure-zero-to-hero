# Day 8: Azure Storage Services

Short and simple. The main storage types and how to create one.

---

## Types of Azure Storage

| Type | What it's for | Example use | AWS Equivalent |
|------|---------------|-------------|----------------|
| **Blob Storage** | Files/objects (images, videos, backups, logs) | Store app uploads, static website files | **Amazon S3** |
| **File Storage** | Managed file shares (SMB/NFS) | Shared drive for multiple VMs | **Amazon EFS / FSx** |
| **Queue Storage** | Messages between app components | Decouple services, background jobs | **Amazon SQS** |
| **Table Storage** | NoSQL key-value data | Simple structured data, fast lookups | **Amazon DynamoDB** |
| **Disk Storage** | Virtual hard disks for VMs | OS and data disks attached to VMs | **Amazon EBS** |

---

## Real-World Use Cases

- **Blob** → website images, video streaming, backups, big data.
- **File** → lift-and-shift apps needing a shared network drive.
- **Queue** → order processing: web app drops a message, a worker picks it up.
- **Table** → device/user metadata where you need cheap, fast NoSQL.
- **Disk** → the disks your VMs boot from and store data on.

---

## Redundancy (how many copies Azure keeps)

- **LRS** → 3 copies in one data center (cheapest).
- **ZRS** → copies across availability zones.
- **GRS** → copies in a second region (disaster recovery).

---

## Step 1: Create a Storage Account
1. Portal → search `Storage accounts` → **+ Create**.
2. **Resource group**: `rg-day8-storage`.
3. **Name**: `stday8demo123` (lowercase, globally unique).
4. **Region**: pick one close to you.
5. **Performance**: Standard, **Redundancy**: LRS.
6. **Review + create** → **Create**.

## Step 2: Create a Blob Container
1. Open the storage account → **Containers** → **+ Container**.
2. **Name**: `uploads`, **Access level**: Private.
3. **Create**.

## Step 3: Upload a File
1. Open the `uploads` container → **Upload**.
2. Pick any file from your computer → **Upload**.
3. Click the file → copy its **URL** (needs access/SAS to open if private).

## Step 4: Create a File Share (optional)
1. Storage account → **File shares** → **+ File share**.
2. **Name**: `shared`, set a small quota → **Create**.
3. Use **Connect** to mount it on a VM.

## Step 5: Generate a SAS token (secure temporary access)
1. Storage account → **Shared access signature**.
2. Choose permissions + expiry → **Generate SAS**.
3. Use the SAS URL to share a file safely for a limited time.

## Step 6: Clean up
1. Delete resource group `rg-day8-storage`.

---

## ✅ Remember
- **Blob** = objects/files, **File** = shared drive, **Queue** = messages, **Table** = NoSQL, **Disk** = VM disks.
- **Redundancy** decides how many copies and where (LRS → ZRS → GRS).
- Use **SAS tokens** to give safe, time-limited access instead of making data public.
