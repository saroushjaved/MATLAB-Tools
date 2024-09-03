clc;  % Clear the command window

% Define the message and divisor
message = 0b1101100111011010u32;  % 16-bit message
message_len = 16;  % Message length
divisor = 0b1111u32;  % 4-bit divisor
divisor_len = 4;  % Divisor length
degree = divisor_len - 1; % the number of bits to be added to the message for CRC

% Append zeros to the message and divisor (= degree)
message_app = bitshift(message, divisor_len - 1);
divisor_app = bitshift(divisor, message_len - 1);

%just some stuff to display if need be
disp('The Message Bit Original:');
disp(dec2bin(message_app));
disp('Divisor Bit Original:');
disp(dec2bin(divisor_app));

% CRC encoding
for i = 1:message_len
    % Get the most significant bit of the message_app 
    a = bitget(message_app, message_len + degree);
    % Display the current bit 'a'
    disp(dec2bin(a));
    
    if bitget(message_app, message_len + degree) % This is getting the MSB of the message singal with appended zeros and hence as later when we shift it the value changed
        % XOR the message_app with the divisor_app if the MSB is 1
        message_app = bitxor(message_app, divisor_app);
        % Display the updated message_app
        disp(dec2bin(message_app));
    end
    
    % Shift message_app one bit to the left
    message_app = bitshift(message_app, 1);
end

% Calculate the CRC value
CRC_val = bitshift(message_app, -message_len);
disp('CRC Value:');
disp(dec2bin(CRC_val));

% Transmitted message
message_app = bitshift(message, degree);
trans = bitor(message_app, CRC_val);
disp('Transmitted Message:');
disp(dec2bin(trans));

% Performing the CRC check
for i = 1:message_len
    if bitget(trans, message_len + degree)
        % XOR the transmitted message with the divisor_app if the MSB is 1
        trans = bitxor(trans, divisor_app);
        % Display the updated transmitted message
        disp(dec2bin(trans));
    end
    
    % Shift the transmitted message one bit to the left
    trans = bitshift(trans, 1);
end

% Check for errors
remainder = bitshift(trans, -message_len);
if remainder == 0
    disp('There are no errors');
else
    disp('There are errors');
end
