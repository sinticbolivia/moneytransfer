project('MoneyRequest', 'vala', 'c', version: '1.0.0')
vapi_dir = meson.current_source_dir()  + '/src/vapi'
inc_directories = ['.']
SO_TARGET = get_option('so_target')
sbframework_dir = get_option('libsinticbolivia')
install_dir = get_option('install_dir')

link_args = []
subsystem = false

# add libSinticBolivia library
add_project_arguments(['--pkg', 'SinticBolivia'], language: 'vala')
dependencies = [
	dependency('glib-2.0'),
	dependency('gobject-2.0'),
	dependency('gmodule-2.0'),
	dependency('gee-0.8'),
	dependency('json-glib-1.0'),
	dependency('libxml-2.0'),
	dependency('sqlite3'),
	meson.get_compiler('vala').find_library('mysql'),
    dependency('libpq'),
]
# LIBSOUP
dsoup = dependency('libsoup-3.0', version: '>=3.0.4', required: false)
if dsoup.found()
	dependencies += dsoup
else
	dependencies += dependency('libsoup-2.4', version: '>=2.64.2')
endif
# DESKTOP FRAMEWORK
add_project_arguments(['--vapidir', meson.current_source_dir() + '/' + sbframework_dir], language: 'vala')
dependencies += meson.get_compiler('c').find_library('SinticBolivia', dirs: meson.current_source_dir() + '/' + sbframework_dir)
inc_directories = ['../' + sbframework_dir]
link_args += '-L' + meson.current_source_dir() + '/' + sbframework_dir
link_args += '-lSinticBolivia'

if SO_TARGET == 'MACOS'
	# add_project_arguments(['--vapidir', meson.current_source_dir() + '/' + sbframework_dir], language: 'vala')
	# dependencies += dependency('libsoup-3.0', version: '>=3.0.4')
	# dependencies += meson.get_compiler('c').find_library('SinticBolivia', dirs: meson.current_source_dir() + '/' + sbframework_dir)
	# inc_directories = ['../' + sbframework_dir]
	# link_args += '-L' + meson.current_source_dir() + '/' + sbframework_dir
	# link_args += '-lSinticBolivia'
elif SO_TARGET == 'LINUX'
    # add_project_arguments(['--vapidir', meson.current_source_dir() + '/' + sbframework_dir], language: 'vala')
    # dependencies += meson.get_compiler('c').find_library('SinticBolivia', dirs: meson.current_source_dir() + '/' + sbframework_dir)
    # inc_directories = ['../' + sbframework_dir]
    # link_args += '-L' + meson.current_source_dir() + '/' + sbframework_dir
    # link_args += '-lSinticBolivia'
endif

message('MESON BASE DIR', meson.current_source_dir() )
message('SBFRAMEWORK PATH: ' + sbframework_dir)

include_dir = include_directories(inc_directories)
sources = [
    'src/Dto/DtoMoneyRequest.vala',
    'src/Dto/DtoAttachmentData.vala',
    'src/Dto/DtoResponse.vala',
	'src/Dto/DtoVeriffSession.vala',
	'src/Dto/DtoVeriffMedia.vala',
	'src/Dto/DtoVeriffRequest.vala',
	'src/Dto/DtoVeriffResponse.vala',
    'src/Classes/UserProfile.vala',
	'src/Entities/Parameter.vala',
    'src/Entities/Attachment.vala',
    'src/Entities/MoneyRequest.vala',
	'src/Entities/PaymentMethod.vala',
    'src/Entities/RequestState.vala',
	'src/Entities/Wallet.vala',
	'src/Entities/WalletCharge.vala',
	'src/Entities/Withdraw.vala',
	'src/Services/ServiceFirebase.vala',
	'src/Services/ServiceVeriff.vala',
    'src/Models/AuthenticationModel.vala',
    'src/Models/MoneyRequestsModel.vala',
	'src/Models/WalletsModel.vala',
	'src/Controllers/BaseController.vala',
    'src/Controllers/MoneyRequestController.vala',
    'src/Controllers/PaymentMethodsController.vala',
	'src/Controllers/ParametersController.vala',
	'src/Controllers/WalletsController.vala',
	'src/Controllers/WithdrawalsController.vala',
	'src/Controllers/VeriffController.vala',
    'src/mr_module.vala'
]

libmoneyrequests = shared_library(
	'moneyrequests',
	sources,
	dependencies: dependencies,
	include_directories : include_dir,
	install: true,
	install_dir: install_dir,
)
libmoneyrequests_dep = declare_dependency(
	include_directories : include_dir,
	link_with : libmoneyrequests
)
