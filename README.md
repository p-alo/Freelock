# Freelock 🛡️💼

**Decentralized Freelancing with Escrow-Based Payments and Trustless Reputation**

## Overview

**Freelock** is a Clarity smart contract that powers decentralized freelancing by securing payments in escrow and automating milestone-based releases. It also incorporates a transparent reputation system based on verified client reviews. Freelock eliminates intermediaries and empowers both freelancers and clients with security, autonomy, and fairness.

## Key Features

🔐 **Escrow-Based Payment System**
Clients deposit funds into escrow, which are held securely until milestones are met and verified.

⚙️ **Milestone Automation**
Freelancers receive payments automatically when the client confirms milestone completion.

🌟 **Reputation Engine**
Freelancers build a decentralized reputation through client ratings after each completed job.

🛠️ **Dispute Safeguards**
Funds remain locked during disputes, protecting both parties until a resolution is reached.

🧾 **Transparent Workflow**
All transactions and reviews are recorded on-chain, ensuring traceability and trust.

---

## Workflow

1. **Project Creation**

   * Client creates a project, defines milestones, and deposits total payment into escrow.

2. **Freelancer Acceptance**

   * A freelancer accepts the offer and begins work.

3. **Milestone Submission & Verification**

   * Freelancer submits work per milestone.
   * Client approves and triggers automatic fund release.

4. **Project Completion & Rating**

   * After the final milestone, client leaves a rating and review.
   * Freelancer’s reputation score is updated.

5. **Dispute Resolution** *(optional enhancement)*

   * Funds stay locked if either party raises a dispute.
   * Arbitrators or community validators resolve the dispute.

---

## Benefits

* ✅ **No Intermediaries**: Fully decentralized, trustless contract.
* 💰 **Fair Payments**: Ensures freelancers are paid only when work is verified.
* 🧠 **Informed Hiring**: Transparent freelancer profiles with reputation scores.
* 🛡️ **Fraud Prevention**: Locked funds and review-based trust discourage abuse.

---

## Deployment & Usage

* Written in **Clarity** for the **Stacks Blockchain**.
* Deploy using the [Clarity CLI](https://docs.stacks.co/docs/clarity/clarity-cli) or integrated Stacks IDEs like Clarinet or Hiro IDE.
* Functions include:

  * `create-project`
  * `accept-project`
  * `submit-milestone`
  * `verify-milestone`
  * `release-funds`
  * `leave-review`

---

## Future Enhancements

* 🧑‍⚖️ Multi-party arbitration system
* 🔐 Zero-knowledge milestone proofs
* 🪪 DID (Decentralized Identity) integration for verified profiles

---

## License

MIT License. Open-source and free to use with credit.