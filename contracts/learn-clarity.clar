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
;; PRIMITIVES: Primitive types are the most basic components. These are: signed and unsigned integers, booleans, and principals.

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

;; modulo
(mod 2 5)

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
(define-data-var standard-principal principal 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE)

;; Contract principals are a compound of the standard principal 
;; that deployed the contract and the contract name, delimited by a dot:
(define-data-var contract-principal principal 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.my-awesome-contract)

;;You will use the principal type often when writing Clarity. 
;; It is used to check who is calling the contract, recording 
;; information about different principals, function calls across contracts, 
;; and much more.
;; To retrieve the current STX balance of a principal, we can pass it 
;; to the stx-get-balance function.
(stx-get-balance tx-sender)
;; Both kinds of principals can hold tokens, we can thus also check the balance of a contract.
(stx-get-balance (var-get  standard-principal))

;;transfering to a principal 
(stx-transfer? u500 tx-sender (var-get contract-principal))


;; SEQUENCES: Sequences hold a sequence of data, as the name implies. Clarity provides three different kinds of sequences: buffers, strings, and lists.
;; Buffers:
;; Buffers are unstructured data of a fixed maximum length. 
;; They always start with the prefix 0x followed by a hexadecimal string.
;; Each byte is thus represented by two so-called hexits.
(define-data-var buffer (buff 10) 0x68656c6c6f21)
;; The buffer above spells out "hello!"

;; Strings:
;; A string is a sequence of characters. 
;; These can be defined as ASCII strings or UTF-8 strings. 
;; ASCII strings may only contain basic Latin characters 
;; whilst UTF-8 strings can contain fun stuff like emoji. 
;; Both strings are enclosed in double-quotes (") 
;; but UTF-8 strings are also prefixed by a u. Just like buffers, 
;; strings always have a fixed maximum length in Clarity.
;; defining string ascii with max-len of 5
(define-data-var name (string-ascii 5) "hello")
;; defining string utf-8 with max-len of 5
(define-data-var id (string-utf8 20) u"user \u{1f601}")

;; Lists
;; Lists are sequences of fixed length that contain another type. 
;; Since types cannot mix, a list can only contain items of the same type. 
;; Take this list of signed integers for example:
;; defining a list variable
(define-data-var array (list 5 int) (list 1 2))
;; (list 1 2 3 4 6)
;; (list "Hello" "HO" "hi")
;; (list u2 u5 u4)

;; You can iterate over a list using the map or fold functions.
;; map applies an input function to each element and returns a new list with the updated values.
;; The not function inverts a boolean (true becomes false and false becomes true). 
;; We can thus invert a list of booleans like this:
(map not (list true true false true)) ;;outputs [false, false, true, true]
(map + (list 1 2))

;; fold applies an input function to each element of the 
;; list and the output value of the previous application. 
;; It also takes an initial value to use for the second input 
;; for the first element. The returned result is the last value 
;; returned by the final application. This function is also 
;; commonly called reduce, because it reduces a list to a single value. 
;; We can use fold to sum numbers in a list by applying 
;; the + (addition) function with an initial value of u0:
(fold + (list u1 u2 u3) u0) ;;outputs u6

;; WORKING WITH SEQUENCES
;; Length: Sequences always have a specific length, which we can retrieve using the len function.
;; A buffer (remember that each byte is represented as two hexits):
(len 0x68656c6c6f21) ;; outputs u6
;; A string
(len "How long is this string?") ;; outputs u24
;; A list
(len (list 4 8 15 16 23 42)) ;; outputs u6

;; Retrieving elements
(element-at (list 4 8 15 16 23 42) u3) ;; outputs (some 16)
;; get the index of an element
(index-of (list 4 8 15 16 23 42) 8) ;; outputs (some u1)

;; COMPOSITE TYPES: These are more complex types that contain a number of other types. Composites make it a lot easier to create larger smart contracts.
;; Optionals:
;; The type system in Clarity does not allow for empty values. 
;; It means that a boolean is always either true or false, 
;; and an integer always contains a number. But sometimes 
;; you want to be able to express a variable that could have some value, 
;; or nothing. For this you use the optional type. 
;; This type wraps a different type and can either be none or a value 
;; of that type. The optional type is very powerful and the tooling 
;; will perform checks to make sure they are handled properly in the code.
;; Let us look at a few examples.
;; defining an optional variable
(define-data-var my-optional (optional int) (some 0))

;; Wrapping a uint:
(some u5)

;; An ASCII string:
(some "An optional containing a string")

;; a principal
(some 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE)

;; Nothing is represented by the keyword none:
(some none)

;; Functions that might or might not return a value tend 
;; to return an optional type. As we saw in the previous section, 
;; both element-at and index-of returned a (some ...). 
;; It is because for some inputs, no matching value can 
;; be found. We can take the same list but this time try 
;; to retrieve an element at an index larger than the 
;; total size of the list. We see that it results in a none value.
(element-at (list 4 8 15 16 23 42) u5000) ;; outputs none
;; setting my-optional variable
(var-set my-optional (element-at (list 4 8 15 16 23 42) u5000))
;; When writing smart contracts, the developer must handle cases 
;; where (some ...) is returned differently from when none is returned.
;; In order to access the value contained within an optional, 
;; you have to unwrap it.
(unwrap-panic (some u10)) ;; outputs u10
;; Trying to unwrap a none will result in an error because 
;; there is nothing to unwrap. The "panic" in unwrap-panic should 
;; give that away.
;; (unwrap-panic none)

;; Tuples:
;; Tuples are records that hold multiple values in named fields. 
;; Each field has its own type, making it very useful to pass 
;; along structured data in one go. Tuples have their own 
;; special formatting and use curly braces.
;; defining a tuple variable
(define-data-var my-tuple (tuple (user-id int)) (tuple (user-id 0)))

;; you can use this style
(tuple 
  (id u4) ;; a uiint
  (username "collins") ;; a ascii string
  (address 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE) ;; a principal
)
;; or this style
{
    id: u5, ;; a uint
    username: "ClarityIsAwesome", ;; an ASCI string
    address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE ;; and a principal
}
;; A specific member can be read using the get function.
(get username {id: 5, username: "collins"})
;; Tuples, like other values, are immutable once defined. 
;; It means that they cannot be changed. You can, however, 
;; merge two tuples together to form a new tuple. 
;; Merging is done from left to right and will overwrite values 
;; with the same key.
(merge 
    {id: 5, score: 10, username: "ClarityIsAwesome"}
    {score: 20, winner: true}
) ;; outputs {id: 5, score: 20, username: "ClarityIsAwesome", winner: true}

;; Responses:
;; A response is a composite type that wraps another type just like 
;; an optional. What is different, however, is that a response 
;; type includes an indication of whether a specific action was 
;; successful or a failure. Responses have special effects 
;; when returned by public functions. We will cover those 
;; effects in the chapter on functions.
;; A response takes the concrete form of either (ok ...) or (err ...). 
;; Wrapping a value in a concrete response is straightforward:
;; defining a response variable
(define-data-var my-response (response bool uint) (ok true))

(ok true)
;; Developers usually come up with their own rules to indicate 
;; error status. You could for example use unsigned integers 
;; to represent a specific error code.

(err u5) ;; something went wrong

;; Responses can be unwrapped in the same way as optional types:
(unwrap-panic (ok true))
;; Although not necessary, private functions and read-only functions may also return a response type.

;; KEYWORDS
;; true
;; false
;; none
;; block-height: Reflects the current block height of the Stacks blockchain as an unsigned integer. If we imagine the chain tip to be at height 5, we can read that number at any point in our code.
;; burn-block-height: Reflects the current block height of the underlying burn blockchain (in this case Bitcoin) as an unsigned integer.
;; tx-sender: Contains the principal that sent the transaction. 
;; It can be used to validate the principal that is calling into 
;; a public function. Note that it is possible for the tx-sender 
;; to be a contract principal if the special function as-contract was 
;; used to shift the sending context. (as-contract tx-sender)
;; contract-caller: Contains the principal that called the function. 
;; It can be a standard principal or contract principal. If the contract 
;; is called via a signed transaction directly, then tx-sender 
;; and contract-caller will be equal. If the contract calls another 
;; contract in turn, then contract-caller will be equal to the 
;; previous contract in the chain.


;; CONSTANTS
;;Constants are data members that cannot be changed once 
;; they are defined (hence the name constant). 
;; They are useful to define concrete configuration values, 
;; error codes, and more. The general form to define a constant 
;; looks like this: (define-constant constant-name expression)

;; defining a constant variable
(define-constant constant 0)
(define-constant my-constant "this is a constant value")
(define-constant my-second-constant (concat my-constant "that depends on another"))
(define-constant my-list (list 1 2))
;; A common pattern that you will come across is that of 
;;defining a constant to store the principal that deployed 
;; the contract:
(define-constant contract-owner tx-sender)
;; Constants are also useful to give return values and errors meaningful names.
(define-constant err-something-failed (err u500)) ;; And then use err-something-failed instead of (err u100) later in the code.
;; MAPS
;; Data maps are so-called hash tables. It is a kind of 
;; data structure that allows you to map keys to specific 
;; values. Unlike tuple keys, data map keys are not 
;; hard-coded names. They are represented as a specific 
;; concrete values. You should use maps if you want to relate 
;; data to other data. (define-map map-name key-type value-type)
;; defining a map variable
(define-map my-map principal uint)
;; setting a map
(map-set my-map tx-sender u500)
;; retrive balance
(map-get? my-map tx-sender) ;; outputs (some u500)

;;Let us take a look at how we can use a map to store and
;; read basic orders by ID. We will use an unsigned integer
;; for the key type and a tuple for the value type. 
;; These fictional orders will hold a principal and an amount.
(define-map orders uint (tuple (maker principal) (amount uint)))
;; set two orders
(map-set orders u0 (tuple (maker tx-sender) (amount u50)))
(map-set orders u1 (tuple (maker tx-sender) (amount u120)))
;; retrive order with ID u1
(map-get? orders u1) 
;; Set and insert
;; The map-set function will overwrite existing values 
;; whilst map-insert will do nothing and return false 
;; if the specified key already exists. Entries may also be 
;; deleted using map-delete.
(define-map scores principal uint)
;; insert a value
(map-insert scores tx-sender u100)
;; This second insert will do nothing because the key already exists.
(map-insert scores tx-sender u200)
;; The score for tx-sender will be u100.
(print (map-get? scores tx-sender))
;; Delete the entry for tx-sender.
(map-delete scores tx-sender)
;; Will return none because the entry got deleted.
(print (map-get? scores tx-sender))

;; Reading from a map might fail
;; What we have seen from the previous examples 
;; is that map-get? returns an optional type. 
;; The reason is that reading from a map fails if the 
;; provided key does not exist. When that happens, 
;; map-get? returns a none. It also means that if 
;; you wish to use the retrieved value, you will 
;; have to unwrap it in most cases

;; A map that creates a string-ascii => uint relation.
(define-map names (string-ascii 34) principal)
;; Point the name "Clarity" to the tx-sender.
(map-set names "Clarity" tx-sender)
;; Retrieve the principal related to the name "Clarity".
(map-get? names "Clarity")
;; Retrieve the principal for a key that does not exist. It will return `none`.
(map-get? names "collins")
;; Unwrap a value:
(unwrap-panic (map-get? names "Clarity"))

;; FUNCTIONS
;; Public Functions: can be called externally. That means that 
;; another standard principal or contract principal can invoke 
;; the function. Public function calls require sending a transaction. 
;; The sender thus need to pay transaction fees. All public function must return a response type.
;; Public functions must return a response type value. 
;; If the function returns an ok type, then the function call is 
;; considered valid, and any changes made to the blockchain state 
;; will materialise. It means that state changes such as 
;; updating variables or transferring tokens will only be committed 
;; to the chain if the contract call that triggered these changes 
;; returns an ok
;; defining a public function
(define-public (hello-world) (ok "success"))

(define-public (add-number (a int) (b int)) (ok (* a b)))

(define-public (print-twice (first (string-ascii 20)) (second (string-utf8 20))) 
   (begin
      (print first)
      (print second)
      (ok true)
   )
)

(define-data-var  even-values uint u0)
(define-public (count-even (number uint)) 
   (begin  
      ;; increment the "event-values" variable by one.
      (var-set even-values (+ (var-get even-values) u1))
      ;; check if the input number is even (number mod 2 equals 0).
      (if (is-eq (mod number u2) u0)
        (ok "the number is even")
        ;; when an err response is called  the entire public 
        ;; function call is rolled back or reverted as soon as 
        ;; it returns an err value. It is as if the function call
        ;; never happened! It therefore does not matter if you 
        ;; update the variable at the start or end of the function.
        (err "the number is uneven")
      )
   )
)
(print (count-even u4))
(print (count-even u7))
(print (var-get even-values))
;; Private Functions: can only be called by the current 
;; contract there is no outside access. 
;; (Although the source code can obviously still be inspected
;; by reading the blockchain.) They cannot be called from other 
;; smart contracts, nor can they be called directly by sending a 
;; transaction. Private functions are useful to create utility 
;; or helper functions to cut down on code repetition
;; Private functions may return any type, including responses, 
;; although returning an ok or an err will have no effect on 
;; the materialised state of the chain.
;; defining a private function
(define-private (hello) (print "hello"))
;; The contract bellow allows only the contract owner to update 
;; the recipients map via two public functions. Instead of having 
;; to repeat the tx-sender check, it is abstracted away to its 
;; own private function called is-valid-caller.
(define-constant contract-owner-x tx-sender)
(define-constant err-invalid-caller (err u1))
(define-map recipients principal uint)

(define-private (is-valid-caller) 
  (is-eq tx-sender contract-owner-x)
)

(define-public (add-recipient (recipient principal) (amount uint)) 
  (if (is-valid-caller)
    (ok (map-set recipients recipient amount))
    err-invalid-caller
  )
)

(define-public (delete-recipient (recipient principal)) 
  (if (is-valid-caller ) 
     (ok (map-delete recipients recipient))
     err-invalid-caller
  )
)
(print (add-recipient 'ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK u500))
(print (delete-recipient 'ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK))


;; Read only functions: can be called externally but may not change 
;; the chain state. Sending a transaction is not necessary to 
;; call a read-only function
;; defining a read only function
(define-read-only (my-read-only-func) (print "my read only func"))
(define-read-only (addition (a int) (b int)) 
  (+ a b)
)
(define-data-var counting uint u2)
(define-read-only (get-counter-value) 
  (var-get counting)
)
;; The expressions that define functions take exactly 
;; one expression for the function body. The function body 
;; is what is executed when the function is called. 
;; If the body is limited to one expression only, then how 
;; can you create more complex functions that require multiple 
;; expression? For this, a special form exists. 
;; The variadic begin function takes an arbitrary amount of 
;; inputs and will return the result of the last expression.
(begin 2 3 4) ;; outputs 4

;; CONTROL FLOW AND ERROR HANDLING
;; The first print expression is evaluated first, 
;; the second after that, and so on. But there are a few 
;; functions that actually influence the control flow. 
;; These are aptly named control flow functions. 
;; If understanding responses is key to becoming 
;; a successful smart contract developer, then understanding 
;; control functions is key to becoming a great smart contract developer. 
;; The names of the control flow functions are: asserts!, try!, unwrap!, unwrap-err!, unwrap-panic, and unwrap-err-panic.
;; Another useful thing to understand with control flow 
;; functions is the difference between functions 
;; that end in an exclamation point (such as unwrap!), 
;; and those that do not (such as unwrap-panic). 
;; Those that end in an exclamation point allow for arbitrary 
;; early returns from a function. Those that do not 
;; terminate execution altogether and throw a runtime error.

;; asserts!
;; The asserts! function takes two parameters, 
;; the first being a boolean expression and the second a 
;; so-called throw value. If the boolean expression evaluates 
;; to true, then asserts! returns true and execution continues 
;; as expected, but if the expression evaluates to false then 
;; asserts! will return the throw value and exit the current 
;; control flow. That sounds complicated, so let us take a 
;; look at some examples. Keep in mind that the basic form
;; for asserts! as described looks like this:
;; (asserts! boolean-expression throw-value)
(asserts! true (err "failed"))
(asserts! false (err "falied"))
;;  Let us make it more clear with a test function. 
;; The test function takes a boolean input value and asserts 
;; its truthiness. For a throw value we will use an err
;; and the final expression will return an ok.
(define-public (assert-example (value bool)) 
   (begin 
      (asserts! value (err "the assertion failed"))
      (ok "end of the function")
   )
)
(print (assert-example true))
(print (assert-example false))

(define-public (add-recipient-assert-example (recipient principal) (amount uint)) 
  (begin  
    (asserts! (is-valid-caller) err-invalid-caller)
    (ok (map-set recipients recipient amount))
  )
)

;; try!
;; The try! function takes an optional or a response type 
;; and will attempt to unwrap it. Unwrapping is the act of 
;; extracting the inner value and returning it. 
;; Take the following example:
(try! (some "wrapped string"))
;; try! can only successfully unwrap some and ok values. 
;; If it receives a none or an err, it will return the input 
;; value and exit the current control flow. In other words:
(define-public (try-example (input (response uint uint))) 
  (begin 
    (try! input)
    (ok "end of the function")
  )
)
(print (try-example (ok u1)))
(print (try-example (err u2)))

;; in clarity types fall in three categories: primitives, sequences, composites
;; Primitives are the basic building blocks for the language. They include numbers and boolean values (true and false).
;; Sequences hold multiple values in order.
;; Composites are complex types that are made up of other types.

;; Smart contracts have their own private storage space. 
;; You can define different types of data members to use 
;; throughout your smart contract. These data members are committed 
;; to the chain and thus persist across transactions. For example, 
;; a first transaction can change a data member after which a second 
;; one reads the updated value. All data members have to be 
;; defined on the top level of the contract and are identified by a 
;; unique name. No new data members can be introduced after the 
;; contract has been deployed. Clarity permits three different
;; kinds of storage: constants, variables, and data maps.

;; In Clarity, we have public, private, and read only functions. 
;; Public allow you to modify chain state and can be called from 
;; anywhere, private do the same except they can only be called 
;; from within the contract, and read only will fail if they 
;; attempt to modify state.


(define-public (asserting-x (name-x (buff 4))) 
  (begin 
    (asserts! true (err "Failed"))
    (ok "end")
  )
)

(define-public (write-messge (message (string-utf8 50))) 
  (ok message)
)