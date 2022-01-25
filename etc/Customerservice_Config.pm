Set(
    %CustomFieldGroupings,
    'RT::Ticket' => [
        'Service Information' => [ 'Customer', 'Order #', 'Product', 'Serial #', 'Severity', 'Warranty Required', 'Warranty Order #' ],
        'Supplier Information' => [ 'Supplier', 'Supplier PO #', 'Supplier Warranty Order #' ],
    ],
);
Set(
    %LinkedQueuePortlets,
    (
        'Service' => [
            { 'Supplier' => [ 'All' ] },
        ],
        'Supplier' => [
            { 'Service' => [ 'All' ] },
        ],
    )
);
