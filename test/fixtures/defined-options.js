
/*jslint white: false */

function whenYouHaveAGoodProof() {
}

function itsProven() {
}

var proof = "a proof";

// normally this file would fail because of whitespace reasons, but the
// whitespace option has been disabled
if(proof === proof && whenYouHaveAGoodProof()) {
  itsProven();
}