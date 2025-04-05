# Change to a login page html
extends ColorRect
class_name HTMLLoginPage

var window: JavaScriptObject
var console: JavaScriptObject
@export var line_edit: LineEdit

@export_file("*.tscn") var login_complete_scene: String

var receiveCredential:= JavaScriptBridge.create_callback(
	func(args):
		var response = args[0] if args.size() > 0 else null
		print(response)
		console.log(response)
		hide_login()
)

var godotReceiveEmailPassword:= JavaScriptBridge.create_callback(
	func(args:Array):
		console.log(args)
		if args.size() != 2: # expecting two args
			push_error("an argumet is missing")
		else:
			var info = {
				"email": args[0],
			}
			hide_login()
			encryipt_and_store(args[1], info)
			line_edit.text = args[1]
)

#region test later
# test later
func load_login_html():
	var js_code = """
		function showLoginForm() {
			// Check if login form is already present
			let loginBody = document.getElementById('login-body');

			if (!loginBody) {
				// Create login body container
				loginBody = document.createElement('div');
				loginBody.id = 'login-body';
				loginBody.style.display = 'block';

				// Add title
				const title = document.createElement('h2');
				title.className = 'login-title';
				title.textContent = 'Sign In';

				// Create form
				const form = document.createElement('form');
				form.className = 'login-form';

				// Email input (industry standard)
				const emailInput = document.createElement('input');
				emailInput.type = 'email';
				emailInput.placeholder = 'Email';
				emailInput.required = true;
				emailInput.autocomplete = 'email';
				emailInput.inputMode = 'email';
				emailInput.name = 'email';

				// Password input (industry standard)
				const passwordInputWrapper = document.createElement('div');
				passwordInputWrapper.style.position = 'relative'; // To position toggle button

				const passwordInput = document.createElement('input');
				passwordInput.type = 'password';
				passwordInput.placeholder = 'Password';
				passwordInput.required = true;
				passwordInput.autocomplete = 'current-password';
				passwordInput.name = 'password';
				passwordInput.minLength = 8; // Optional: Enforce min length

				// Show/Hide Password Button
				const togglePasswordBtn = document.createElement('button');
				togglePasswordBtn.type = 'button';
				togglePasswordBtn.textContent = 'Show';
				togglePasswordBtn.style.position = 'absolute';
				togglePasswordBtn.style.right = '10px';
				togglePasswordBtn.style.top = '50%';
				togglePasswordBtn.style.transform = 'translateY(-50%)';
				togglePasswordBtn.style.padding = '4px 8px';

				// Toggle logic
				togglePasswordBtn.addEventListener('click', () => {
				  if (passwordInput.type === 'password') {
					passwordInput.type = 'text';
					togglePasswordBtn.textContent = 'Hide';
				  } else {
					passwordInput.type = 'password';
					togglePasswordBtn.textContent = 'Show';
				  }
				});

				// Append password input and toggle button together
				passwordInputWrapper.appendChild(passwordInput);
				passwordInputWrapper.appendChild(togglePasswordBtn);

				// Submit button
				const submitButton = document.createElement('button');
				submitButton.type = 'submit';
				submitButton.className = 'login-button';
				submitButton.textContent = 'Sign In';

				// Append all to form
				form.append(emailInput, passwordInputWrapper, submitButton);

				// Append title and form to body
				loginBody.appendChild(title);
				loginBody.appendChild(form);

				// Optional: Close button for UX
				const closeBtn = document.createElement('button');
				closeBtn.textContent = 'X';
				closeBtn.className = 'close-button';
				closeBtn.style.position = 'absolute';
				closeBtn.style.top = '10px';
				closeBtn.style.right = '10px';
				closeBtn.addEventListener('click', () => {
				  loginBody.style.display = 'none';
				});

				loginBody.appendChild(closeBtn);

				// Append to document body
				document.body.appendChild(loginBody);
		}
	showLoginForm()
	"""
	JavaScriptBridge.eval(js_code, true)

func load_login_css():
	var js_code = """
function injectLoginStyles() {
  // Check if styles are already added
  if (document.getElementById('login-styles')) return;

  const style = document.createElement('style');
  style.id = 'login-styles'; // So we don't duplicate styles
  style.textContent = `
	#login-body {
	  display: flex;
	  position: absolute;
	  width: 100%;
	  z-index: 1;
	  background-color: black;
	  justify-content: center;
	  align-items: center;
	  height: 100vh;
	  font-family: Arial, sans-serif;
	}

	#login-container {
	  background-color: #1a1a1a;
	  border-radius: 8px;
	  padding: 30px;
	  width: 320px;
	  box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
	  position: relative;
	}

	.login-title {
	  text-align: center;
	  margin-bottom: 25px;
	  font-size: 24px;
	  color: #ffffff;
	}

	.login-form input {
	  width: 100%;
	  padding: 12px;
	  margin-bottom: 15px;
	  border: none;
	  border-radius: 4px;
	  background-color: #333;
	  color: white;
	  box-sizing: border-box;
	}

	.login-form input::placeholder {
	  color: #aaa;
	}

	.login-button {
	  width: 100%;
	  padding: 12px;
	  background-color: #4CAF50;
	  color: white;
	  border: none;
	  border-radius: 4px;
	  cursor: pointer;
	  font-size: 16px;
	  margin-bottom: 20px;
	}

	.login-button:hover {
	  background-color: #45a049;
	}

	.divider {
	  display: flex;
	  align-items: center;
	  text-align: center;
	  margin: 15px 0;
	}

	.divider::before,
	.divider::after {
	  content: '';
	  flex: 1;
	  border-bottom: 1px solid #444;
	}

	.divider-text {
	  padding: 0 10px;
	  color: #888;
	}

	.google-signin-wrapper {
	  display: flex;
	  justify-content: center;
	  margin-top: 10px;
	}

	.close-button {
	  position: absolute;
	  top: 10px;
	  right: 10px;
	  background: transparent;
	  border: none;
	  color: white;
	  font-size: 18px;
	  cursor: pointer;
	}

	.close-button:hover {
	  color: #ff4d4d;
	}
  `;
  document.head.appendChild(style);
}
injectLoginStyles();
	"""
	JavaScriptBridge.eval(js_code, true)
#endregion

func _ready() -> void: # add login with passpharse later
	if OS.has_feature("web"): # add email or address which ever they use
		window = JavaScriptBridge.get_interface('window')
		console = JavaScriptBridge.get_interface('console')
		window.godotReceiveCredential = receiveCredential
		window.godotReceiveEmailPassword = godotReceiveEmailPassword
		if not FileAccess.file_exists(SaveLoader.save_path):
			show_login()
			pass

# Call this to show login module
func show_login():
	visibile(true)

func toggle_element_display(element_id: String, visiblility: bool, show_option = "block"):
	var display_value = "none" if not visiblility else show_option
	var js_code = """
		document.getElementById('%s').style.display = '%s';
	""" % [element_id, display_value]
	JavaScriptBridge.eval(js_code, true)

func visibile(value:bool, show_option = "flex"):
	toggle_element_display("login-body", value, show_option)

func encryipt_and_store(key, info):
	var wallet = Web3Global.wallet_manager.connect_custom_wallet(key)
	#Crypto.new() # use to increase security
	info["address"] = wallet.address
	info["secrets"] = wallet.encryptSync(key)
	SaveLoader.save_with_key(key, info)
	# initalize all the contracts here for later calling
	pass

# Call this to hide login module
func hide_login():
	visibile(false)

func _on_button_pressed() -> void:
	var tokens = SaveLoader.load_with_key(line_edit.text)
	if tokens:
		var wallet = Web3Global.wallet_manager.connect_custom_wallet(line_edit.text, tokens["secrets"])
		_initailaize_contract("address", PrecompliedAddressContract.new("", wallet))
		print("sucesss")
		window.alert("Success")
	else:
		printerr("Failed")

func _initailaize_contract(contact_name:String, contract):
	#contract.contract = Web3Global.contract_manager.set_runner(contract.contract, wallet)
	Web3Global.contracts[contact_name] = contract

func _on_register_pressed() -> void:
	show_login()
