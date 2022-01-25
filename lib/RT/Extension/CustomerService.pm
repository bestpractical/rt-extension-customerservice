use strict;
use warnings;
package RT::Extension::CustomerService;

our $VERSION = '0.01';

=head1 NAME

RT-Extension-CustomerService - Default Customer Service configuration for Request Tracker

=head1 RT VERSION

Works with RT 4.4, 5.0

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt5/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::CustomerService');

B<If you don't add the Plugin line and save, you will see errors in the next step.>

=item C<make initdb>

Only run this the first time you install this module.

If you run this twice, you may end up with duplicate data in your database.

If you are upgrading this module, check for upgrading instructions in case
changes need to be made to your database.

=item Clear your mason cache

    rm -rf /opt/rt5/var/mason_data/obj

=item Restart your webserver

=back

=head1 DESCRIPTION

One common use for Request Tracker (RT) is tracking customer issues, typically
related to customer service. "Customer Service" is often a department, either a
designated department with many agents for large organizations, or sometimes
only one or two people who handle all customer service for a smaller
organization.

RT is used to track incoming customer service requests so they don't get lost
and can be assigned to individual people to handle. It's also useful for
gathering general reporting on the volume of customer service requests and what
types of problems seem to generate the most requests.

This extension provides an L<initialdata|https://docs.bestpractical.com/rt/latest/initialdata.html/> file
to configure a service queue and a supplier queue with some sensible default
rights configured for a typical customer service department. Once installed, you
can then edit the configuration to best suit your needs.

=head2 Service Queue

After installing, you'll see a new queue called L<Service> for tracking all of
the incoming customer service requests. In a typical configuration, you will
also want to assign an RT email address, like service@example.com or
cs@example.com to create tickets in this queue.

=head2 Supplier Queue

After installing, you'll also see a second new queue called L<Supplier> for
tracking all interactions with your different suppliers. If a customer service
request requires you to contact a supplier you can open a dependent ticket in
the supplier queue to track the interaction there. This keeps your
communication with your supplier separate from your communication with your
customer.
 
=head2 User Groups

Three new user groups are added to handle different aspects of customer service:
Service Representatives, Service Engineers, and Service Managers.

Service Representatives are the front line of the customer service department
and will handle the requests as they come into the system. If they need
assistance from someone with more detailed product knowledge they can set a
ticket status to 'waiting on engineer' and wait for a response.

Service Engineers assist the Service Representatives when an issue requires more
detailed product knowledge. If a ticket has a status of 'waiting for engineer'
they can assist and then set the ticket status back to 'waiting for service' to
indicate they are finished working on it.

Service Managers review requests to ensure the customer needs are being met and
also to track how many requests are coming in, and what is generating those
requests.

=head2 Rights

Some typical initial rights are set on the L<Service> queue. The system group
"Everyone" gets a default set of rights to allow customers to create tickets.
Everyone is a system group provided with RT, and as the name implies it
encompasses every user in RT.

<p>TODO: image for everyone group rights<img width="500px" src="https://static.bestpractical.com/images/customerservice/everyone_group_rights.png"
alt="Group rights for 'Everyone' group on 'Service' queue" /></p>

These rights are usually the minimum needed for a typical customer service
department. Anyone is able to write into your customer service address with a
customer service request, and they can reply and follow-up on that request if
you send them some questions.

The extension also grants "ShowTicket" to the Requestor role. If your end users
have access to RT's self service interface, this allows them to see only tickets
where they are the Requestor, which should be the tickets they opened.

Your staff users will need many more rights to work on tickets. To make it easy
to add and remove access for staff users, this extension creates three new
groups: Service Representatives, Service Engineers, and Service Managers.

Rights are granted to these groups, so membership in the group is all a user
needs to get those rights.

Service Representatives and Service Engineers are granted a set of rights to
allow them to manage the incoming tickets and make changes to the tickets as
required.

<p>TODO: image for rep/eng group rights<img width="500px" src="https://static.bestpractical.com/images/customerservice/rep_eng_group_rights.png"
alt="Group rights for 'Service Representatives' and 'Service Engineers' groups on 'Service' queue" /></p>

Service Managers are granted a set of rights to view tickets but not make any
changes to the tickets.

<p>TODO: image for manager group rights<img width="500px" src="https://static.bestpractical.com/images/customerservice/manager_group_rights.png"
alt="Group rights for 'Service Managers' group on 'Service' queue" /></p>

=head2 Lifecycles

RT allows you to create and configure custom workflows for each queue in the
system.  In RT a ticket workflow is known as a L<Lifecycle|https://docs.bestpractical.com/rt/latest/customizing/lifecycles.html>.

This extension provides two custom lifecycles called "service" and "supplier"
that defines the various statuses a ticket can be in for the service and
supplier queues.

=begin HTML

<p>TODO: image for service lifecycle<img width="500px" src="https://static.bestpractical.com/images/customerservice/service_lifecycle.png"
alt="Lifecycle for 'Service' queue" /></p>

<p>TODO: image for supplier lifecycle<img width="500px" src="https://static.bestpractical.com/images/customerservice/supplier_lifecycle.png"
alt="Lifecycle for 'Supplier' queue" /></p>

=end HTML

=head2 Custom Fields

RT allows you to define custom fields on tickets, which can be anything you need
to record and track. This extension provides some common to customer service.

Tickets in the Service queue have the following custom fields:

=over

=item * Customer

The customer with the issue

=item * Order #

The order # for the product purchase

=item * Product

The product with the issue

=item * Serial #

The serial # of the product

=item * Severity

How serious is the issue?

=item * Supplier

Supplier of the product

=item * Supplier PO #

Your PO # with the supplier that contained the product with the issue. Useful
for tracking if a specific purchase had multiple faulty products.

=item * Warranty Required

Does the issue qualify for a warranty replacement

=item * Warranty Order #

If there is a warranty the order for the replacement

=back

Tickets in the Supplier queue have some of the same custom fields as well as:

=over

=item * Supplier Warranty Order #

If your supplier replaces the product under warranty the supplier order for the
replacement

=back

Customer, Product, and Supplier are autocomplete fields. This means users can
type in the box and if there is a matching value in the list of defined values
for the field, it will autocomplete in a menu below the field. If the user needs
to enter a value that is not one of the defined values, they can enter a
completely new value.

Severity is a dropdown with typical High, Medium, Low values. As an RT admin,
you can change these values or add to them at Admin > Custom Fields, then click
on Severity.

Order #, Serial #, Supplier PO #, Warranty Order #, and Supplier Warranty Order #
are simple text fields that will allow the user to type in a single value.

Warranty Required is a dropdown with Yes or No values.

As an RT admin, you can change the list of defined values for a custom field or
change an autocomplete field to a dropdown field at Admin -> Custom Fields, then
click on the custom field you would like to edit.

=head2 Service Representative Dashboard

This extension creates a dashboard called "Highest severity waiting for service",
accessible to any member of the Service Representative group. This dashboard has
a default saved search called "Highest severity tickets waiting on service".

As the name suggests, this saved search shows all tickets waiting for customer
service and displays them in order by severity, so the most important will be at
the top.

=head2 Service Engineer Dashboard

This extension creates a dashboard called "Highest severity waiting for engineer",
accessible to any member of the Service Engineer group. This dashboard has a
default saved search called "Highest severity tickets waiting on engineer".

As the name suggests, this saved search shows all tickets waiting for customer
service engineers (status of 'waiting for engineer') and displays them in order
by severity, so the most important will be at the top.

=head2 Next Steps

This extension provides a good starting point and you can start using it right
away. Here are some additional things you can do to customize your
configuration:

=over

=item *

Create new user accounts for other staff and add them to one of the new Groups.
You might also remove the root user if that user account won't be involved in
customer service.

=item *

Update the custom fields by changing the values in the dropdowns or adding other
custom fields that better fit your system.

=item *

Edit your templates to customize the default messages you send to users. You can
find templates at Admin > Global > Templates. For example, the
"Autoreply in HTML" is the default template that goes to users when they open a
ticket.

=item *

The RT administrator can add one of the new dashboards to user Reports menu by
going to Admin -> Users -> Select -> Modify Reports menu.

=back

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=for html <p>All bugs should be reported via email to <a
href="mailto:bug-RT-Extension-CustomerService@rt.cpan.org">bug-RT-Extension-CustomerService@rt.cpan.org</a>
or via the web at <a
href="http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-CustomerService">rt.cpan.org</a>.</p>

=for text
    All bugs should be reported via email to
        bug-RT-Extension-CustomerService@rt.cpan.org
    or via the web at
        http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-CustomerService

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2022 by BPS

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
