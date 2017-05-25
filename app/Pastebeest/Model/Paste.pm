package Pastebeest::Model::Paste {
    use Mojo::Pg;
    use Mojo::Base 'Pastebeest::Model';
    use Pastebeest::Model::User;
    
    sub table { "pastes" };
    sub index { "slug" };

    ## HAVE --
    # this overly verbose monstrocity probably does what I want. Not sure, because my postgres db keeps dying.
    # Pastebeest::Model->belongs_to("Pastebeest::Model::Paste", "Pastebeest::Model::User", "user", "user_id");

    ## WANT --
    # belongs_to should monkey_patch a new sub into this model with the lower case name of the target model ("user"),
    # which should return the user for which this table has a <lowercase modelname>_id field, e.g.
    # User->where("id", $self->user_id);
    # Bonuspoints if belongs_to can override the sub name and id field with optional (named?) arguments
    __PACKAGE__->SUPER::belongs_to("Pastebeest::Model::User");
}

1;
