# Architecture

## Design principles

- **Preventative over reactive** — Azure Policy Deny effects stop insecure configs before they deploy
- **Least privilege** — RBAC assignments scoped to minimum required permissions
- **No public exposure** — no public IPs, no open NSG rules by default
- **Immutable critical resources** — `prevent_destroy = true` + `CanNotDelete` management locks
- **RBAC-only Key Vault** — legacy access policies disabled

## Module dependency graph

```
root
├── modules/governance     (resource groups, locks, tags)
├── modules/policy         (Azure Policy definitions + assignments)
├── modules/networking     (hub VNet, subnets, NSGs)
├── modules/key-vault      (Key Vault, RBAC roles)
├── modules/rbac           (custom role definitions, assignments)
└── modules/storage-secure (Storage accounts, secure transfer)
```

## Backend

- **Local** — development / CI validation (no Azure resources needed)
- **Azure Storage** — production state (Storage Account + container in `rg-tfstate`)

## Policy definitions (modules/policy/definitions/)

| File | Effect | What it prevents |
|---|---|---|
| `deny-public-ip.json` | Deny | Creating public IP addresses |
| `deny-http.json` | Deny | HTTP (non-HTTPS) traffic |
| `require-tags.json` | Deny | Resources without required tags |
| `deny-old-tls.json` | Deny | TLS versions below 1.2 |
| `audit-mfa.json` | Audit | Accounts without MFA (audit only) |
| `deny-unencrypted-storage.json` | Deny | Storage without encryption |

## Networking (hub-spoke)

```
hub-vnet (10.0.0.0/16)
└── subnet-mgmt (10.0.1.0/24)  — management traffic only

spoke-vnet (10.1.0.0/16)       — future workloads
```

No peering wired by default — added when workloads require it.

## Intune integration (conceptual)

intune_lab handles **endpoint trust** (device compliance, Conditional Access).  
This project handles **Azure cloud infrastructure security**.  
They share the same tenant (`dpintune.onmicrosoft.com`) but have no code coupling.
