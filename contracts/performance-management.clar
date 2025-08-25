;; Performance Management Contract
;; Manages show schedules, performance details, and analytics

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u200))
(define-constant ERR-PERFORMANCE-NOT-FOUND (err u201))
(define-constant ERR-PERFORMANCE-EXISTS (err u202))
(define-constant ERR-INVALID-DATE (err u203))
(define-constant ERR-VENUE-NOT-FOUND (err u204))
(define-constant ERR-PERFORMANCE-ENDED (err u205))

;; Data Variables
(define-data-var next-performance-id uint u1)

;; Data Maps
(define-map performances
  { performance-id: uint }
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    venue-id: uint,
    performance-date: uint,
    duration-minutes: uint,
    genre: (string-ascii 50),
    rating: (string-ascii 10),
    is-active: bool,
    tickets-sold: uint,
    revenue-generated: uint,
    created-at: uint
  }
)

(define-map performance-cast
  { performance-id: uint, cast-member: (string-ascii 100) }
  {
    role: (string-ascii 100),
    is-lead: bool
  }
)

(define-map performance-analytics
  { performance-id: uint }
  {
    total-attendance: uint,
    accessibility-tickets: uint,
    group-tickets: uint,
    season-subscriber-tickets: uint,
    average-price: uint,
    satisfaction-rating: uint
  }
)

(define-map performance-schedule
  { venue-id: uint, date: uint }
  { performance-id: uint }
)

;; Public Functions

;; Create a new performance
(define-public (create-performance
  (title (string-ascii 100))
  (description (string-ascii 500))
  (venue-id uint)
  (performance-date uint)
  (duration-minutes uint)
  (genre (string-ascii 50))
  (rating (string-ascii 10)))
  (let
    (
      (performance-id (var-get next-performance-id))
    )
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (> performance-date block-height) ERR-INVALID-DATE)
    (asserts! (is-none (map-get? performance-schedule { venue-id: venue-id, date: performance-date })) ERR-PERFORMANCE-EXISTS)

    (map-set performances
      { performance-id: performance-id }
      {
        title: title,
        description: description,
        venue-id: venue-id,
        performance-date: performance-date,
        duration-minutes: duration-minutes,
        genre: genre,
        rating: rating,
        is-active: true,
        tickets-sold: u0,
        revenue-generated: u0,
        created-at: block-height
      }
    )

    (map-set performance-schedule
      { venue-id: venue-id, date: performance-date }
      { performance-id: performance-id }
    )

    (map-set performance-analytics
      { performance-id: performance-id }
      {
        total-attendance: u0,
        accessibility-tickets: u0,
        group-tickets: u0,
        season-subscriber-tickets: u0,
        average-price: u0,
        satisfaction-rating: u0
      }
    )

    (var-set next-performance-id (+ performance-id u1))
    (print { event: "performance-created", performance-id: performance-id, title: title })
    (ok performance-id)
  )
)

;; Add cast member to performance
(define-public (add-cast-member
  (performance-id uint)
  (cast-member (string-ascii 100))
  (role (string-ascii 100))
  (is-lead bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (is-some (map-get? performances { performance-id: performance-id })) ERR-PERFORMANCE-NOT-FOUND)

    (map-set performance-cast
      { performance-id: performance-id, cast-member: cast-member }
      {
        role: role,
        is-lead: is-lead
      }
    )

    (print { event: "cast-member-added", performance-id: performance-id, cast-member: cast-member })
    (ok true)
  )
)

;; Update performance analytics
(define-public (update-performance-analytics
  (performance-id uint)
  (tickets-sold uint)
  (revenue uint)
  (accessibility-tickets uint)
  (group-tickets uint)
  (season-tickets uint))
  (let
    (
      (performance (unwrap! (map-get? performances { performance-id: performance-id }) ERR-PERFORMANCE-NOT-FOUND))
      (analytics (unwrap! (map-get? performance-analytics { performance-id: performance-id }) ERR-PERFORMANCE-NOT-FOUND))
      (average-price (if (> tickets-sold u0) (/ revenue tickets-sold) u0))
    )
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)

    (map-set performances
      { performance-id: performance-id }
      (merge performance {
        tickets-sold: tickets-sold,
        revenue-generated: revenue
      })
    )

    (map-set performance-analytics
      { performance-id: performance-id }
      (merge analytics {
        total-attendance: tickets-sold,
        accessibility-tickets: accessibility-tickets,
        group-tickets: group-tickets,
        season-subscriber-tickets: season-tickets,
        average-price: average-price
      })
    )

    (print { event: "analytics-updated", performance-id: performance-id })
    (ok true)
  )
)

;; Cancel performance
(define-public (cancel-performance (performance-id uint))
  (let
    (
      (performance (unwrap! (map-get? performances { performance-id: performance-id }) ERR-PERFORMANCE-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (> (get performance-date performance) block-height) ERR-PERFORMANCE-ENDED)

    (map-set performances
      { performance-id: performance-id }
      (merge performance { is-active: false })
    )

    (print { event: "performance-cancelled", performance-id: performance-id })
    (ok true)
  )
)

;; Read-only Functions

;; Get performance details
(define-read-only (get-performance (performance-id uint))
  (map-get? performances { performance-id: performance-id })
)

;; Get performance cast
(define-read-only (get-cast-member (performance-id uint) (cast-member (string-ascii 100)))
  (map-get? performance-cast { performance-id: performance-id, cast-member: cast-member })
)

;; Get performance analytics
(define-read-only (get-performance-analytics (performance-id uint))
  (map-get? performance-analytics { performance-id: performance-id })
)

;; Get performance by venue and date
(define-read-only (get-performance-by-schedule (venue-id uint) (date uint))
  (map-get? performance-schedule { venue-id: venue-id, date: date })
)

;; Check if performance is active
(define-read-only (is-performance-active (performance-id uint))
  (match (map-get? performances { performance-id: performance-id })
    performance (and (get is-active performance) (> (get performance-date performance) block-height))
    false
  )
)

;; Get next performance ID
(define-read-only (get-next-performance-id)
  (var-get next-performance-id)
)
