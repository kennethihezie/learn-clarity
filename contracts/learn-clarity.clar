;; title: learn-clarity
;; version: 1.0.0
;; summary: learning clarity
;; description: learning clarity

;; in clarity Such expressions always follow the same basic pattern: 
;; an opening round brace (, followed by a function name, 
;; optionally followed by a number of input parameters, 
;; and closed by a closing round brace ). The different parts 
;; inside the braces are separated by whitespace.
;; The + symbol in the example below really has no special 
;; significance. It is just a function name.
(+ 4 5)
(concat "Hello" " World")

;; convert 4 * (15 + 10) to clarity
(* 4 (+  15 10))

;; convert (5 * 4) - 5
(- (* 5 4) 5)

;; TYPES
;; in clarity types fall in three categories: primitives, sequences, composites
;; Primitives: Primitive types are the most basic components. These are: signed and unsigned integers, booleans, and principals.

;; Signed integers:
;; int, short for (signed) integer. These are 128 bits numbers that can 
;; either be positive or negative. The minimum value is -2127 and the 
;; maximum value is 2127 - 1. Some examples: 0, 5000, -45.
;; defining an integer variable
(define-data-var count int 0)


;; Unsigned integers:
;; uint, short for unsigned integer. These are 128 bits numbers 
;; that can only be positive. The minimum value is therefore 0 
;; and the maximum value is 2128 - 1. Unsigned integers are 
;; always prefixed by the character u. Some examples: u0, u40935094534.
;; defining an unsigned integer
(define-data-var unsigned-integer uint u0)

;; Clarity has many built-in functions that accept either signed or unsigned integers:
;; Addition for unsigined integer
(+ u2 u3)
;; Addition for integer
(+ 5 2)

;; Subtraction for unsigined integer
(- u20 u8)
;; Subtraction for integer
(- 10 20)

;; Multiplication for unsigined integer
(* u8 u35)
;; Multiplication for integer
(* 30 35)

;; divide for unsigined integer
(/ u5 u2)
;; divide for integer
(/ 4 2)
;; there are no decimal points. It is something to keep in mind when writing your code

;; Booleans
;; bool, short for boolean. A boolean value is either true or false. 
;; They are used to check if a certain condition is met or unmet (true or false). 
;; defining a boolean variable
(define-data-var isTrue bool true)

;; Some built-in functions that accept booleans:
;; not (inverts a boolean):
(not true)

;; and (returns true if all inputs are true): Note you can add multiple parameters
(and true true false)
(and (< 2 4) (is-eq 5 10))

;; or (returns true if at least one input is true):
(or false true false)

;; Principals
;; A principal is a special type in Clarity and represents 
;; a Stacks address on the blockchain. It is a unique identifier 
;; you can roughly equate to an email address or bank account 
;; number although definitely not the same! You might have also 
;; heard the term wallet address as well. Clarity admits 
;; two different kinds of principals: standard principals 
;; and contract principals. Standard principals are backed 
;; by a corresponding private key whilst contract principals 
;; point to a smart contract. Principals follow a specific 
;; structure and always start with the characters SP for the Stacks mainnet 
;; and ST for the testnet and mocknet1.
;; A literal principal value is prefixed by a single quote (') in Clarity. 
;; Notice there is no closing single quote.
;; the tx-sender is the current address like msg.sender in solidity
;; Eg of standard principal:
'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE

;; Contract principals are a compound of the standard principal 
;; that deployed the contract and the contract name, delimited by a dot:
'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.my-awesome-contract

;;You will use the principal type often when writing Clarity. 
;; It is used to check who is calling the contract, recording 
;; information about different principals, function calls across contracts, 
;; and much more.
;; To retrieve the current STX balance of a principal, we can pass it 
;; to the stx-get-balance function.
(stx-get-balance tx-sender)
;; Both kinds of principals can hold tokens, we can thus also check the balance of a contract.
(stx-get-balance 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE)

;;transfering to a principal 
(stx-transfer? u500 tx-sender 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE)














;; defining a constant variable
(define-constant constant 0)


;; defining string ascii with max-len of 5
(define-data-var name (string-ascii 5) "hello")

;; defining string utf-8 with max-len of 5
(define-data-var id (string-utf8 5) u"user")


;;defining a public function
(define-public (hello-world) (begin (print "Hello World") (ok "Success")))
;; defining a private function
(define-private (hello) (print "hello"))

(define-public (add-number (number int))
   ;; all function body can contain a single expression
   ;; So this let function is a way of wrapping 
   ;; a multi-step function into a single argument.
   (let 
        (
          ;; Sets a variable that only exists in the context of 
          ;; this particular function. So here we are saying, 
          ;; create a new variable called current-count and set 
          ;; it equal to the value of count  
          (current-count (var-get count))
        ) 
        ;; here we are setting the value of our count variable 
        ;; to 1 plus whatever number we passed in. 
        ;; The + is just another call to a function where 
        ;; the parameters are the numbers we want to add.
        (var-set count (+ 1 number))
        ;; here we are returning the new value of count 
        ;; with our ok response, indicating that the function 
        ;; completed successfully.
        (print (var-get count))
        (ok (var-get count))
    )
)

;; in clarity types fall in three categories: primitives, sequences, composites
;; Primitives are the basic building blocks for the language. They include numbers and boolean values (true and false).
;; Sequences hold multiple values in order.
;; Composites are complex types that are made up of other types.

;; In Clarity, we have public, private, and read only functions. 
;; Public allow you to modify chain state and can be called from 
;; anywhere, private do the same except they can only be called 
;; from within the contract, and read only will fail if they 
;; attempt to modify state.
