# 🏦 CryptoBankBasic

📖 **Description**  
CryptoBankBasic is a smart contract written in Solidity (^0.8.24) that acts as a simple Ether vault for multiple users. It allows users to deposit and withdraw ETH, with a configurable per-user deposit cap enforced by an admin. The contract is designed with simplicity, safety, and extensibility in mind — ideal as a foundation for more advanced DeFi features.

This project is great for Solidity learners, developers building on-chain wallets, or anyone exploring custodial ETH banking systems without token integration.

---

✨ **Key Features**

- **ETH Deposit**: Users can securely deposit ETH into the contract, subject to a configurable limit.
- **User Withdrawals**: Users can withdraw up to their deposited balance at any time.
- **Admin Controls**: An admin can update the per-user deposit cap.
- **Transparent Events**: Emits events on deposits and withdrawals for on-chain auditability.
- **Minimal Reentrancy Risk**: State updates occur before external calls.
- **Safe Fallback Handling**: Prevents accidental ETH transfers via `receive()` and `fallback()`.

---

💼 **Use Cases**

- **On-chain wallets** for individual users with balance limits.
- **Crypto banks or custodians** managing deposits with admin oversight.
- **ETH-only dApps** needing secure balance tracking without ERC20s.
- **Learning tool** for understanding mappings, `msg.value`, and access control.

---

🚀 **Installation & Usage**

🧱 **Requirements**

- Solidity development environment (Remix, Hardhat, Foundry, etc.)
- Ethereum wallet (MetaMask, WalletConnect, etc.)
- Ethereum node or testnet access (Remix VM, Sepolia, etc.)

📦 **Deployment**

1. Open `CryptoBankBasic.sol` in Remix.
2. Compile using Solidity `0.8.24`.
3. Deploy to the Remix VM or a testnet.
4. Use the UI or scripts to interact with functions:
   - `depositEth()`
   - `withdrawEth(uint256 amount)`
   - `modifyBalance(uint256 newMaxBalance)`
   - `contractBalance()`

---

💬 **Interacting with the Contract**

### 1. Deposit ETH (`depositEth`)
- Called by any user.
- Accepts ETH via `msg.value`.
- Requires:
  - The deposit + previous balance ≤ `maxBalance`.
- Emits `EtherDeposited`.

### 2. Withdraw ETH (`withdrawEth`)
- Called by the depositing user.
- Transfers up to the user’s balance.
- Emits
