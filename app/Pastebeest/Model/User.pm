package Pastebeest::Model::User {
    use Mojo::Pg;
    use Mojo::Base 'Pastebeest::Model';

    sub table { "users" };
    sub index { "username" };

    # has_many("Pastebeest::Model::Paste", "pastes", "user_id");
}

1;
