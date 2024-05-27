defmodule RocketchatWeb.Icons do
  use Phoenix.Component

  def search_icon(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
      <g
        fill="none"
        fill-rule="evenodd"
        stroke="#200E32"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="1.5"
        transform="translate(2 2)"
      >
        <circle cx="9.767" cy="9.767" r="8.989" /><line x1="16.018" x2="19.542" y1="16.485" y2="20" />
      </g>
    </svg>
    """
  end

  def home_icon(assigns) do
    ~H"""
    <svg width="21" height="22" viewBox="0 0 21 22" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path
        d="M7.65722 19.7714V16.7047C7.6572 15.9246 8.29312 15.2908 9.08101 15.2856H11.9671C12.7587 15.2856 13.4005 15.9209 13.4005 16.7047V19.7809C13.4003 20.4432 13.9343 20.9845 14.603 21H16.5271C18.4451 21 20 19.4607 20 17.5618V8.83784C19.9898 8.09083 19.6355 7.38935 19.038 6.93303L12.4577 1.6853C11.3049 0.771566 9.6662 0.771566 8.51342 1.6853L1.96203 6.94256C1.36226 7.39702 1.00739 8.09967 1 8.84736V17.5618C1 19.4607 2.55488 21 4.47291 21H6.39696C7.08235 21 7.63797 20.4499 7.63797 19.7714"
        stroke="#200E32"
        stroke-width="1.5"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
    </svg>
    """
  end

  def notification_icon(assigns) do
    ~H"""
    <svg width="19" height="22" viewBox="0 0 19 22" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path
        d="M7.05494 19.8518C7.55421 20.4784 8.2874 20.884 9.09223 20.9787C9.89706 21.0734 10.7072 20.8495 11.3433 20.3564C11.5389 20.2106 11.7149 20.041 11.8672 19.8518M1.00083 12.7871V12.5681C1.03295 11.9202 1.2406 11.2925 1.60236 10.7496C2.2045 10.0975 2.6167 9.29831 2.79571 8.43598C2.79571 7.7695 2.79571 7.0935 2.85393 6.42703C3.15469 3.21842 6.32728 1 9.46106 1H9.53867C12.6725 1 15.845 3.21842 16.1555 6.42703C16.2137 7.0935 16.1555 7.7695 16.204 8.43598C16.3854 9.3003 16.7972 10.1019 17.3974 10.7591C17.7618 11.2972 17.9698 11.9227 17.9989 12.5681V12.7776C18.0206 13.648 17.7208 14.4968 17.1548 15.1674C16.407 15.9515 15.3921 16.4393 14.3024 16.5384C11.107 16.8812 7.88303 16.8812 4.68762 16.5384C3.59914 16.435 2.58576 15.9479 1.83521 15.1674C1.278 14.4963 0.982241 13.6526 1.00083 12.7871Z"
        stroke="#200E32"
        stroke-width="1.5"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
    </svg>
    """
  end

  def direct_message_icon(assigns) do
    ~H"""
    <svg width="21" height="19" viewBox="0 0 21 19" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path
        d="M16.2686 6.56104L12.0031 9.99531C11.1959 10.6282 10.0644 10.6282 9.25714 9.99531L4.95508 6.56104"
        stroke="#200E32"
        stroke-width="1.5"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M5.88787 1H15.3158C16.6752 1.01525 17.969 1.58993 18.896 2.5902C19.823 3.59048 20.3022 4.92903 20.222 6.29412V12.822C20.3022 14.1871 19.823 15.5256 18.896 16.5259C17.969 17.5262 16.6752 18.1009 15.3158 18.1161H5.88787C2.96796 18.1161 1 15.7407 1 12.822V6.29412C1 3.37545 2.96796 1 5.88787 1Z"
        stroke="#200E32"
        stroke-width="1.5"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
    </svg>
    """
  end

  def person_icon(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24">
      <path fill="none" d="M0 0h24v24H0V0z" /><path d="M12 5.9c1.16 0 2.1.94 2.1 2.1s-.94 2.1-2.1 2.1S9.9 9.16 9.9 8s.94-2.1 2.1-2.1m0 9c2.97 0 6.1 1.46 6.1 2.1v1.1H5.9V17c0-.64 3.13-2.1 6.1-2.1M12 4C9.79 4 8 5.79 8 8s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4zm0 9c-2.67 0-8 1.34-8 4v2c0 .55.45 1 1 1h14c.55 0 1-.45 1-1v-2c0-2.66-5.33-4-8-4z" />
    </svg>
    """
  end

  def heart_icon(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 32 32">
      <path d="M16,27.14a1,1,0,0,1-.71-.29L6.1,17.66a7.5,7.5,0,0,1,5.3-12.8A7.44,7.44,0,0,1,16,6.43a7.52,7.52,0,0,1,9.9.62h0a7.52,7.52,0,0,1,0,10.61l-9.19,9.19A1,1,0,0,1,16,27.14ZM11.4,6.86A5.46,5.46,0,0,0,7.51,8.47a5.52,5.52,0,0,0,0,7.78L16,24.73l8.49-8.48a5.52,5.52,0,0,0,0-7.78h0a5.5,5.5,0,0,0-7.78,0,1,1,0,0,1-1.42,0A5.46,5.46,0,0,0,11.4,6.86Z" />
    </svg>
    """
  end

  def repost_icon(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 32 32">
      <path d="m6 8 6 6H8v6h10v4H4V14H0zm8 0h14v10h4l-6 6-6-6h4v-6H14z" />
    </svg>
    """
  end

  def share_icon(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 22 22">
      <g
        stroke="#000"
        stroke-width="2"
        fill="none"
        fill-rule="evenodd"
        stroke-linecap="round"
        stroke-linejoin="round"
      >
        <path d="M1 11v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8M13 5 9 1 5 5M9 1v13" />
      </g>
    </svg>
    """
  end
end
