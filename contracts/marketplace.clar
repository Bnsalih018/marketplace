;; -------------------------------------------------------------
;; Simple Marketplace Contract
;; -------------------------------------------------------------
;; Features:
;; - Sellers can list items with a price (in microSTX).
;; - Buyers can purchase listed items by sending enough STX.
;; - Anyone can query item details.
;; -------------------------------------------------------------

(define-map items uint
  {
    seller: principal,
    price: uint,
    sold: bool
  }
)

(define-data-var item-counter uint u0)

;; -------------------------------------------------------------
;; Public Functions
;; -------------------------------------------------------------

;; List a new item for sale
(define-public (list-item (price uint))
  (let ((id (+ (var-get item-counter) u1)))
    (begin
      (map-set items id {seller: tx-sender, price: price, sold: false})
      (var-set item-counter id)
      (ok id)
    )
  )
)

;; Buy an item by ID
(define-public (buy (id uint))
  (let ((item (map-get? items id)))
    (match item i
      (begin
        (asserts! (not (get sold i)) (err u700)) ;; already sold?
        (try! (stx-transfer? (get price i) tx-sender (get seller i))) ;; transfer payment to seller
        (map-set items id {seller: (get seller i), price: (get price i), sold: true})
        (ok true)
      )
      (err u702) ;; item not found
    )
  )
)

;; -------------------------------------------------------------
;; Read-Only Functions
;; -------------------------------------------------------------

;; Get details of an item by ID
(define-read-only (get-item (id uint))
  (map-get? items id)
)

;; Get the current number of items
(define-read-only (get-item-count)
  (var-get item-counter)
)
