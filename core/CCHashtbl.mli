
(*
copyright (c) 2013-2014, simon cruanes
all rights reserved.

redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.  redistributions in binary
form must reproduce the above copyright notice, this list of conditions and the
following disclaimer in the documentation and/or other materials provided with
the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*)


(** {1 Open-Addressing Hash-table} *)

type 'a sequence = ('a -> unit) -> unit

module type S = sig
  type key
  type 'a t

  val create : int -> 'a t
  (** Create a new table of the given initial capacity *)

  val mem : 'a t -> key -> bool
  (** [mem tbl k] returns [true] iff [k] is mapped to some value
      in [tbl] *)

  val find : 'a t -> key -> 'a option

  val find_exn : 'a t -> key -> 'a

  val get : key -> 'a t -> 'a option
  (** [get k tbl] recovers the value for [k] in [tbl], or
      returns [None] if [k] doesn't belong *)

  val get_exn : key -> 'a t -> 'a

  val add : 'a t -> key -> 'a -> unit
  (** [add tbl k v] adds [k -> v] to [tbl], possibly replacing the old
      value associated with [k]. *)

  val remove : 'a t -> key -> unit
  (** Remove binding *)

  val size : _ t -> int
  (** Number of bindings *)

  val of_list : (key * 'a) list -> 'a t
  val to_list : 'a t -> (key * 'a) list

  val of_seq : (key * 'a) sequence -> 'a t
  val to_seq : 'a t -> (key * 'a) sequence

  val keys : _ t -> key sequence
  val values : 'a t -> 'a sequence
end

module type HASHABLE = sig
  type t
  val equal : t -> t -> bool
  val hash : t -> int
end

module Make(X : HASHABLE) : S with type key = X.t