from django.conf import settings
from django.http import FileResponse, HttpResponse
from django.views.decorators.cache import never_cache


@never_cache
def frontend_app(request, path=''):
    index_path = settings.FRONTEND_DIST / 'index.html'

    if not index_path.exists():
        return HttpResponse(
            'Frontend build not found. Build the frontend or run the Vite dev server.',
            status=503,
        )

    return FileResponse(index_path.open('rb'), content_type='text/html')
