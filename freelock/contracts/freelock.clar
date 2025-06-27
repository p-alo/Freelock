;; Define the contract
(define-constant system-administrator tx-sender)

;; Data structures
(define-data-var current-assignment-id uint u0)

(define-map assignments
  uint ;; assignment-id
  {
    client: principal,
    contractor: (optional principal),
    name: (string-utf8 100),
    details: (string-utf8 500),
    cost: uint,
    phase-count: uint,
    finished-phases: uint,
    is-finished: bool
  }
)

(define-map phase-information
  { assignment-id: uint, phase-id: uint }
  {
    details: (string-utf8 200),
    is-validated: bool,
    is-compensated: bool
  }
)

;; Errors
(define-constant err-unauthorized (err u100))
(define-constant err-assignment-not-found (err u101))
(define-constant err-phase-not-found (err u102))
(define-constant err-invalid-contractor (err u103))
(define-constant err-phase-already-validated (err u104))
(define-constant err-phase-already-compensated (err u105))
(define-constant err-assignment-already-finished (err u106))

;; Create a new project
(define-public (create-assignment (name (string-utf8 100)) (details (string-utf8 500)) (cost uint) (total-phases uint))
  (let ((new-assignment-id (+ (var-get current-assignment-id) u1)))
    (asserts! (is-eq tx-sender system-administrator) err-unauthorized)
    (map-set assignments new-assignment-id
      {
        client: tx-sender,
        contractor: none,
        name: name,
        details: details,
        cost: cost,
        phase-count: total-phases,
        finished-phases: u0,
        is-finished: false
      }
    )
    (var-set current-assignment-id new-assignment-id)
    (ok new-assignment-id)
  )
)

;; Assign a freelancer to a project
(define-public (assign-contractor (aid uint) (contractor principal))
  (let ((assignment (map-get? assignments aid)))
    (asserts! (is-some assignment) err-assignment-not-found)
    (asserts! (is-eq (get client (unwrap-panic assignment)) tx-sender) err-unauthorized)
    (map-set assignments aid
      (merge (unwrap-panic assignment)
        {
          contractor: (some contractor)
        }
      )
    )
    (ok true)
  )
)

;; Submit a milestone
(define-public (submit-phase (aid uint) (phase-id uint) (details (string-utf8 200)))
  (let ((assignment (map-get? assignments aid)))
    (asserts! (is-some assignment) err-assignment-not-found)
    (asserts! (is-eq (get contractor (unwrap-panic assignment)) (some tx-sender)) err-invalid-contractor)
    (map-set phase-information { assignment-id: aid, phase-id: phase-id }
      {
        details: details,
        is-validated: false,
        is-compensated: false
      }
    )
    (ok true)
  )
)

;; Approve a milestone
(define-public (validate-phase (aid uint) (phase-id uint))
  (let ((assignment (map-get? assignments aid))
        (phase (map-get? phase-information { assignment-id: aid, phase-id: phase-id })))
    (asserts! (is-some assignment) err-assignment-not-found)
    (asserts! (is-some phase) err-phase-not-found)
    (asserts! (is-eq (get client (unwrap-panic assignment)) tx-sender) err-unauthorized)
    (asserts! (not (get is-validated (unwrap-panic phase))) err-phase-already-validated)
    (map-set phase-information { assignment-id: aid, phase-id: phase-id }
      (merge (unwrap-panic phase)
        {
          is-validated: true
        }
      )
    )
    (map-set assignments aid
      (merge (unwrap-panic assignment)
        {
          finished-phases: (+ (get finished-phases (unwrap-panic assignment)) u1)
        }
      )
    )
    (ok true)
  )
)

;; Release payment for a milestone
(define-public (release-compensation (aid uint) (phase-id uint))
  (let ((assignment (map-get? assignments aid))
        (phase (map-get? phase-information { assignment-id: aid, phase-id: phase-id })))
    (asserts! (is-some assignment) err-assignment-not-found)
    (asserts! (is-some phase) err-phase-not-found)
    (asserts! (is-eq (get client (unwrap-panic assignment)) tx-sender) err-unauthorized)
    (asserts! (get is-validated (unwrap-panic phase)) err-phase-not-found)
    (asserts! (not (get is-compensated (unwrap-panic phase))) err-phase-already-compensated)
    (map-set phase-information { assignment-id: aid, phase-id: phase-id }
      (merge (unwrap-panic phase)
        {
          is-compensated: true
        }
      )
    )
    (ok true)
  )
)

;; Mark project as completed
(define-public (complete-assignment (aid uint))
  (let ((assignment (map-get? assignments aid)))
    (asserts! (is-some assignment) err-assignment-not-found)
    (asserts! (is-eq (get client (unwrap-panic assignment)) tx-sender) err-unauthorized)
    (asserts! (not (get is-finished (unwrap-panic assignment))) err-assignment-already-finished)
    (asserts! (is-eq (get finished-phases (unwrap-panic assignment)) (get phase-count (unwrap-panic assignment))) err-unauthorized)
    (map-set assignments aid
      (merge (unwrap-panic assignment)
        {
          is-finished: true
        }
      )
    )
    (ok true)
  )
)

;; Helper function to get project details
(define-read-only (get-assignment-details (aid uint))
  (map-get? assignments aid)
)

;; Helper function to get milestone details
(define-read-only (get-phase-information (aid uint) (phase-id uint))
  (map-get? phase-information { assignment-id: aid, phase-id: phase-id })
)