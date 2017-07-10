$('input').attr('checked', false);
$('div')
    .filter(function() {
        return this.className.match(/service_toggle_*/);
    }).hide();
function toggle(service_id)
{
    $('.service_toggle_' + service_id).find('input:checked').each(
        function(){
            $('label[for='+this.id+']').trigger('click');
        }
    );
    $('.service_toggle_' + service_id).toggle(500);
}
$('.parent_service').trigger('click');