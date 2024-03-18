package tree_sitter_erlang_test

// @generated

import (
	"testing"

	tree_sitter "github.com/smacker/go-tree-sitter"
	"github.com/tree-sitter/tree-sitter-erlang"
)

func TestCanLoadGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_erlang.Language())
	if language == nil {
		t.Errorf("Error loading Erlang grammar")
	}
}
